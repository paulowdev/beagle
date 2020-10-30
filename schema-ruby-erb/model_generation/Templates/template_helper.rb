#   Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA

#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
 
#       http://www.apache.org/licenses/LICENSE-2.0
 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

require_relative '../Synthax/Types/type_to_string'

# This class lists the available supported languages of beagle schema.
class SupportedLanguages

    attr_accessor :swift, :kotlin, :kotlinBackend, :typeScript

    def initialize
        @swift = "swift"
        @kotlin = "kt"
        @kotlinBackend = "ktBackend"
        @typeScript = "ts"
        
        @dart = "dart" #todo
    end

end

# This class is needed because of the way we treat declarations in diferent languages. 
# If you want to handle diferent basic types in your language, this is the place to add them
#   E.g.: we use interface for kotlin but that word does not exist for swift so we are using protocol instead  
class BasicType < SupportedLanguages
    attr_accessor :grammar

    def initialize
        super
        @grammar = {
            TypesToString.string => {@swift => "String", @kotlin => "String"},
            TypesToString.bool => {@swift => "Bool", @kotlin => "Boolean"},
            TypesToString.interface => {@swift => "protocol", @kotlin => "interface"},
            TypesToString.enum => {@swift => "enum", @kotlin => "enum class"},
            TypesToString.integer => {@swift => "Int", @kotlin => "Int"}
        }

    end
    
end

# This class is a helper with common methods that might be useful on the creation of different 
# language templates. You don't necessarily have to use this, but it will be of a great help if you do.
class TemplateHelper
    
    # The identifier of of the language you want to generate. They are define in SupportedLanguages
    # @return [String]
    attr_accessor :languageIdentifier

    # The default declaration type for your models.
    #   E.g.: swift uses struct
    # @return [String]
    attr_accessor :defaultDeclarationType

    # Initialize method for TemplateHelper. You should definitely assign new values to defaultDeclarativeType and
    # languageIdentifier
    # @return [Bool] indicating wether the object is widget or not
    def initialize
        @defaultDeclarationType = ''
        @languageIdentifier = ''
        @types = BasicType.new
    end

    # Fetches a custom basic type if specified inside grammar in BasicType and if the languageIdentifer exists
    #
    # @param key [String] type identifier
    # @return [String] converted string to specified language or the key itself
    def fetch_type(key)
        if @types.grammar.key?(key) && @types.grammar[key].key?(@languageIdentifier)
            @types.grammar[key][@languageIdentifier]
        else
            key
        end
    end

    # Fetches a built in type if specified inside grammar in BasicType and if the languageIdentifer exists
    #
    # @param key [String] type identifier
    # @return [String] converted string to specified language or the key itself
    def fetch_built_in_type_declaration(key)
        key == nil ? @defaultDeclarationType : fetch_type(key)
    end

    # Adds padding in each line of a given multiline string
    #
    # @param padding [String] string with empty spaces. Preferably a padding that is considered the default padding in your language
    # @param multiplier [Integer] multiplier to be applied to the padding parameter. Use 1 if you don't want a multiplier
    # @param text [String] text in which the padding will be applied
    # @return [String] the input text with padding
    def add_padding(padding, multiplier, text)
        output = ""
        text.each_line do |line|
            output += "#{padding * multiplier}#{line}"
        end

        output
    end

    # Given object_type, this functions returns if such an object is enum or not
    #
    # @param object_type [BaseComponent]
    # @return [Bool] indicating wether the object is enum or not
    def is_enum(object_type)
        object_type.synthax_type.class == EnumType
    end

    # Given object_type, this functions returns if such an object is widget or not
    #
    # @param object_type [BaseComponent]
    # @return [Bool] indicating wether the object is widget or not
    def is_widget(object_type)
        object_type.synthax_type.inheritFrom.include? Widget.new.name
    end

    def getImports(variables, import_manager)
        variables
            .select {|variable| !variable.instance_of? Dictionary }
            .map { |variable| import_manager[variable.typeName] }
            .uniq.filter { |import| !import.empty? }
    end

    # Given object_type, this functions returns if such an object is a server driven component or not
    #
    # @param object_type [BaseComponent]
    # @return [Bool] indicating wether the object is a server driven component or not
    def is_server_driven_component(object_type)
        object_type.synthax_type.inheritFrom.include? ServerDrivenComponent.new.name
    end

end
