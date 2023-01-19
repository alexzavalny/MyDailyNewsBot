module MessageProcessors
  class CatalogProcessor < BaseProcessor
    def process
      send_text(Texts.catalog_is_empty)
    end
  end
end