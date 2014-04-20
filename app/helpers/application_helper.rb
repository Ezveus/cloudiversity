module ApplicationHelper
    def get_ids_of(array)
        if array.is_a?(Array)
            array.map { |e| e.respond_to?(:id) ? e.id : nil }.reject { |e| e.nil? }
        else
            []
        end
    end
end
