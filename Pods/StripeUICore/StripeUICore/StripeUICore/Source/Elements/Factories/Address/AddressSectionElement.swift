//
//  AddressSectionElement.swift
//  StripeUICore
//
//  Created by Mel Ludowise on 10/5/21.
//  Copyright © 2021 Stripe, Inc. All rights reserved.
//

import Foundation
@_spi(STP) import StripeCore
import UIKit

/**
 A section that contains a country dropdown and the country-specific address fields. It updates the address fields whenever the country changes to reflect the address format of that country.

 In addition to the physical address, it can collect other related fields like name.
 */
@_spi(STP) public class AddressSectionElement: ContainerElement {
    /// Describes an address to use as a default for AddressSectionElement
    public struct AddressDetails: Equatable {
        @_spi(STP) public static let empty = AddressDetails()
        var name: String?
        var phone: String?
        var address: Address
        
        /// Initializes an Address
        public init(name: String? = nil, phone: String? = nil, address: Address = .init()) {
            self.name = name
            self.phone = phone
            self.address = address
        }

        public struct Address: Equatable {
            /// City, district, suburb, town, or village.
            var city: String?
            
            /// Two-letter country code (ISO 3166-1 alpha-2).
            var country: String?
            
            /// Address line 1 (e.g., street, PO Box, or company name).
            var line1: String?
            
            /// Address line 2 (e.g., apartment, suite, unit, or building).
            var line2: String?
            
            /// ZIP or postal code.
            var postalCode: String?
            
            /// State, county, province, or region.
            var state: String?
            
            /// Initializes an Address
            public init(city: String? = nil, country: String? = nil, line1: String? = nil, line2: String? = nil, postalCode: String? = nil, state: String? = nil) {
                self.city = city
                self.country = country
                self.line1 = line1
                self.line2 = line2
                self.postalCode = postalCode
                self.state = state
            }
        }
    }
    
    /// Describes which address fields to collect
    public enum CollectionMode: Equatable {
        case all
        /// Collects country and postal code if the country is one of `countriesRequiringPostalCollection`
        /// - Note: Really only useful for cards, where we only collect postal for a handful of countries
        case countryAndPostal(countriesRequiringPostalCollection: [String])
        
        case autoCompletable
    }
    /// Fields that this section can collect in addition to the address
    public struct AdditionalFields {
        public init(
            name: FieldConfiguration = .disabled,
            phone: FieldConfiguration = .disabled,
            billingSameAsShippingCheckbox: FieldConfiguration = .disabled
        ) {
            self.name = name
            self.phone = phone
            self.billingSameAsShippingCheckbox = billingSameAsShippingCheckbox
        }
        
        public enum FieldConfiguration {
            case disabled
            case enabled(isOptional: Bool = false)
        }
        
        public let name: FieldConfiguration
        public let phone: FieldConfiguration
        public let billingSameAsShippingCheckbox: FieldConfiguration
    }
    
    // MARK: Element protocol
    public let elements: [Element]
    public var delegate: ElementDelegate?
    public lazy var view: UIView = {
        let vStack = UIStackView(arrangedSubviews: [addressSection.view, sameAsCheckbox?.view].compactMap { $0 })
        vStack.axis = .vertical
        vStack.spacing = 16
        return vStack
    }()
    
    // MARK: Elements
    let addressSection: SectionElement
    public let name: TextFieldElement?
    public let phone: PhoneNumberElement?
    public let country: DropdownFieldElement
    public private(set) var autoCompleteLine: DummyAddressLine?
    public private(set) var line1: TextFieldElement?
    public private(set) var line2: TextFieldElement?
    public private(set) var city: TextFieldElement?
    public private(set) var state: TextFieldElement?
    public private(set) var postalCode: TextFieldElement?
    public let sameAsCheckbox: CheckboxElement?
    
    // MARK: Other properties
    public var collectionMode: CollectionMode {
        didSet {
            if oldValue != collectionMode {
                updateAddressFields(for: countryCodes[country.selectedIndex], address: nil)
            }
        }
    }
    public var selectedCountryCode: String {
        return countryCodes[country.selectedIndex]
    }
    var addressDetails: AddressDetails {
        let address = AddressDetails.Address(city: city?.text, country: selectedCountryCode, line1: line1?.text, line2: line2?.text, postalCode: postalCode?.text, state: state?.text)
        return .init(name: name?.text, phone: phone?.phoneNumber?.string(as: .e164), address: address)
    }
    public let countryCodes: [String]
    let addressSpecProvider: AddressSpecProvider
    let theme: ElementsUITheme
    let defaults: AddressDetails
    
    // MARK: - Implementation
    /**
     Creates an address section with a country dropdown populated from the given list of countryCodes.

     - Parameters:
       - title: The title for this section
       - countries: List of region codes to display in the country picker dropdown. If nil, the list of countries from `addressSpecProvider` is used instead.
       - locale: Locale used to generate the display names for each country
       - addressSpecProvider: Determines the list of address fields to display for a selected country
       - defaults: Default address to prepopulate address fields with
     */
    public init(
        title: String? = nil,
        countries: [String]? = nil,
        locale: Locale = .current,
        addressSpecProvider: AddressSpecProvider = .shared,
        defaults: AddressDetails = .empty,
        collectionMode: CollectionMode = .all,
        additionalFields: AdditionalFields = .init(),
        theme: ElementsUITheme = .default
    ) {
        let dropdownCountries = countries?.map{$0.uppercased()} ?? addressSpecProvider.countries
        let countryCodes = locale.sortedByTheirLocalizedNames(dropdownCountries)
        self.collectionMode = collectionMode
        self.countryCodes = countryCodes
        self.country = DropdownFieldElement.Address.makeCountry(
            label: String.Localized.country_or_region,
            countryCodes: countryCodes,
            theme: theme,
            defaultCountry: defaults.address.country,
            locale: locale
        )
        self.defaults = defaults
        self.addressSpecProvider = addressSpecProvider
        self.theme = theme
        let initialCountry = countryCodes[country.selectedIndex]
        
        // Initialize additional fields
        self.name = {
            if case .enabled(let isOptional) = additionalFields.name {
                return TextFieldElement.NameConfiguration(defaultValue: defaults.name,
                                                          isOptional: isOptional).makeElement(theme: theme)
            } else {
                return nil
            }
        }()
        self.phone = {
            if case .enabled(let isOptional) = additionalFields.phone {
                return PhoneNumberElement(
                    allowedCountryCodes: countryCodes,
                    defaultCountryCode: initialCountry,
                    defaultPhoneNumber: defaults.phone,
                    isOptional: isOptional,
                    locale: locale,
                    theme: theme
                )
            } else {
                return nil
            }
        }()
        self.sameAsCheckbox = {
            if case .enabled = additionalFields.billingSameAsShippingCheckbox,
               // Country must exist in the dropdown, otherwise this address can't be same as shipping
               let defaultCountry = defaults.address.country, countryCodes.contains(defaultCountry) {
                return CheckboxElement(theme: theme, label: String.Localized.billing_same_as_shipping, isSelectedByDefault: true)
            }
            return nil
        }()
        addressSection = SectionElement(title: title, elements: [], theme: theme)
        elements = ([addressSection, sameAsCheckbox] as [Element?]).compactMap { $0 }
        elements.forEach { $0.delegate = self }


        self.updateAddressFields(
            for: initialCountry,
            address: defaults.address
        )
        country.didUpdate = { [weak self] index in
            guard let self = self else { return }
            self.updateAddressFields(
                for: self.countryCodes[index]
            )
        }
        sameAsCheckbox?.didToggle = { [weak self] isToggled in
            guard let self = self else { return }
            if isToggled {
                // Set the country to the default country
                self.country.selectedIndex = self.country.items.firstIndex {
                    $0.rawData == defaults.address.country ?? ""
                } ?? self.country.selectedIndex
                // Populate our fields with the provided defaults
                self.updateAddressFields(for: defaults.address.country ?? self.country.selectedItem.rawData, address: defaults.address)
            } else {
                // Clear the fields
                self.updateAddressFields(for: self.country.selectedItem.rawData, address: .init())
            }
        }
    }

    /// - Parameter address: Populates the new fields with the provided defaults, or the current fields' text if `nil`.
    private func updateAddressFields(
        for countryCode: String,
        address: AddressDetails.Address? = nil
    ) {
        // Create the new address fields' default text
        let address = address ?? AddressDetails.Address(
            city: city?.text,
            country: nil,
            line1: line1?.text,
            line2: line2?.text,
            postalCode: postalCode?.text,
            state: state?.text
        )
        
        // Get the address spec for the country and filter out unused fields
        let spec = addressSpecProvider.addressSpec(for: countryCode)
        let fieldOrdering = spec.fieldOrdering.filter {
            switch collectionMode {
            case .all:
                return true
            case .countryAndPostal(let countriesRequiringPostalCollection):
                if case .postal = $0 {
                    return countriesRequiringPostalCollection.contains(countryCode)
                } else {
                   return false
                }
            case .autoCompletable:
                return false
            }
        }
        
        if collectionMode == .autoCompletable {
            autoCompleteLine = autoCompleteLine ?? DummyAddressLine(theme: theme)
        } else {
            autoCompleteLine = nil
        }
        // Re-create the address fields
        line1 = fieldOrdering.contains(.line) ?
            TextFieldElement.Address.makeLine1(defaultValue: address.line1, theme: theme) : nil
        line2 = fieldOrdering.contains(.line) ?
            TextFieldElement.Address.makeLine2(defaultValue: address.line2, theme: theme) : nil
        city = fieldOrdering.contains(.city) ?
        spec.makeCityElement(defaultValue: address.city, theme: theme) : nil
        state = fieldOrdering.contains(.state) ?
        spec.makeStateElement(defaultValue: address.state, theme: theme) : nil
        postalCode = fieldOrdering.contains(.postal) ?
        spec.makePostalElement(countryCode: countryCode, defaultValue: address.postalCode, theme: theme) : nil
        
        // Order the address fields according to `fieldOrdering`
        let addressFields: [TextFieldElement?] = fieldOrdering.reduce([]) { partialResult, fieldType in
            // This should be a flatMap but I'm having trouble satisfying the compiler
            switch fieldType {
            case .line:
                return partialResult + [line1, line2]
            case .city:
                return partialResult + [city]
            case .state:
                return partialResult + [state]
            case .postal:
                return partialResult + [postalCode]
            }
        }
        // Set the new address fields, including any additional fields
        addressSection.elements = ([name] + [country] + [autoCompleteLine] + addressFields + [phone]).compactMap { $0 }
    }
    
}

// MARK: - Element
extension AddressSectionElement: Element {
    @discardableResult
    public func beginEditing() -> Bool {
        let firstInvalidNonDropDownElement = elements.first(where: {
            switch $0.validationState {
            case .valid:
                return false
            case .invalid(_, _):
                return !($0 is DropdownFieldElement)
            }
        })
        
        // If first non-dropdown element is auto complete, don't do anything
        if firstInvalidNonDropDownElement === autoCompleteLine {
            return false
        }
        
        return firstInvalidNonDropDownElement?.beginEditing() ?? false
    }
}

// MARK: - ElementDelegate
extension AddressSectionElement: ElementDelegate {
    public func didUpdate(element: Element) {
        /// Returns `true` iff all **displayed** address fields match the given `address`, treating `nil` and "" as equal.
        func displayedAddressEqualTo(address: AddressDetails.Address) -> Bool {
            return address == AddressDetails.Address(
                city: city?.text.nonEmpty ?? address.city?.nonEmpty,
                country: selectedCountryCode,
                line1: line1?.text.nonEmpty ?? address.line1?.nonEmpty,
                line2: line2?.text.nonEmpty ?? address.line2?.nonEmpty,
                postalCode: postalCode?.text.nonEmpty ?? address.postalCode?.nonEmpty,
                state: state?.text.nonEmpty ?? address.state?.nonEmpty
            )
        }

        if let billingSameAsShippingCheckbox = sameAsCheckbox, billingSameAsShippingCheckbox.isSelected, !displayedAddressEqualTo(address: defaults.address) {
            // Deselect checkbox if the address != the shipping address (our `defaults`)
            billingSameAsShippingCheckbox.isSelected = false
        }
        delegate?.didUpdate(element: self)
        
        // Update the selected country in the phone element if the text is empty
        // to match the country picker if they don't match
        if let phone = phone, phone.textFieldElement.text.isEmpty
            && phone.countryDropdownElement.selectedIndex != country.selectedIndex {
            phone.countryDropdownElement.select(index: country.selectedIndex)
        }
    }
}
