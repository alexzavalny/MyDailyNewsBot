module MessageProcessors
  class CatalogProcessor < BaseProcessor
    def process
      @conversation.reply(Texts.catalog_is_empty)
    end
  end
end
