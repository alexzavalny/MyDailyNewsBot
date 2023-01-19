module MessageProcessors
  class CatalogProcessor < BaseProcessor
    def compose_reply
      Texts.catalog_is_empty
    end
  end
end
