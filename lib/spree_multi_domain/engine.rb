# frozen_string_literal: true

module SpreeMultiDomain
  class Engine < Rails::Engine
    engine_name 'solidus_multi_domain'

    config.autoload_paths += %W(#{config.root}/lib)

    class << self
      def activate
        ['app', 'lib'].each do |dir|
          Dir.glob(File.join(File.dirname(__FILE__), "../../#{dir}/**/*_decorator*.rb")) do |c|
            Rails.application.config.cache_classes ? require(c) : load(c)
          end
        end

        ::Spree::Config.searcher_class = ::Spree::Search::MultiDomain
        ApplicationController.include SpreeMultiDomain::MultiDomainHelpers
      end

      def admin_available?
        const_defined?('::Spree::Backend::Engine')
      end

      def api_available?
        const_defined?('::Spree::Api::Engine')
      end

      def frontend_available?
        const_defined?('::Spree::Frontend::Engine')
      end
    end

    config.to_prepare &method(:activate).to_proc

    initializer 'spree.promo.register.promotions.rules' do |app|
      app.config.spree.promotions.rules << ::Spree::Promotion::Rules::Store
    end
  end
end
