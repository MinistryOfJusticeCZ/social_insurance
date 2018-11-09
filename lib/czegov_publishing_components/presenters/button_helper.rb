require 'action_view'

module CzegovPublishingComponents
  module Presenters
    class ButtonHelper
      attr_reader :href, :text, :title, :info_text, :rel, :data_attributes,
        :margin_bottom, :target, :start, :secondary, :secondary_quiet, :destructive

      def initialize(local_assigns)
        @href = local_assigns[:href]
        @text = local_assigns[:text]
        @title = local_assigns[:title]
        @info_text = local_assigns[:info_text]
        @rel = local_assigns[:rel]
        @data_attributes = local_assigns[:data_attributes]
        @margin_bottom = local_assigns[:margin_bottom]
        @target = local_assigns[:target]
        @start = local_assigns[:start]
        @secondary = local_assigns[:secondary]
        @secondary_quiet = local_assigns[:secondary_quiet]
        @destructive = local_assigns[:destructive]
      end

      def link?
        href.present?
      end

      def html_options
        options = { class: css_classes }
        options[:role] = "button" if link?
        options[:type] = "submit" unless link?
        options[:rel] = rel if rel
        options[:data] = data_attributes if data_attributes
        options[:title] = title if title
        options[:target] = target if target
        options
      end

    private

      def css_classes
        classes = %w(btn)
        classes << "btn--start btn-lg" if start
        classes << "gem-c-button--secondary" if secondary
        classes << "gem-c-button--secondary-quiet" if secondary_quiet
        classes << "gem-c-button--destructive" if destructive
        classes << "gem-c-button--bottom-margin" if margin_bottom
        classes.join(" ")
      end
    end
  end
end
