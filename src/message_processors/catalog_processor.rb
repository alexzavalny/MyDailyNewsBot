module MessageProcessors
  class CatalogProcessor < SimpleReplyProcessor
    def reply_with
      Texts.catalog_is_empty
    end
  end
end
