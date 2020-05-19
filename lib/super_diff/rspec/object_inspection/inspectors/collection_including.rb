module SuperDiff
  module RSpec
    module ObjectInspection
      module Inspectors
        class CollectionIncluding < SuperDiff::ObjectInspection::Inspectors::Base
          def self.applies_to?(value)
            SuperDiff::RSpec.a_collection_including_something?(value)
          end

          protected

          def inspection_tree
            SuperDiff::ObjectInspection::InspectionTree.new do
              add_text "#<a collection including ("

              nested do |aliased_matcher|
                insert_array_inspection_of(aliased_matcher.expecteds)
              end

              add_break
              add_text ")>"
            end
          end
        end
      end
    end
  end
end
