# frozen_string_literal: true

require 'roda'
require 'slim'

module CodePraise
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :public, root: 'app/views/public'
    plugin :assets, path: 'app/views/assets',
                    css: 'style.css', js: 'table_row_click.js'
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      routing.public

      # GET /
      routing.root do # rubocop:disable Metrics/BlockLength
        projects = Repository::For.klass(Entity::Project).all
        view 'home', locals: { projects: projects }
      end

      routing.on 'project' do
        routing.is do
          # POST /project/
          routing.post do
            gh_url = routing.params['github_url'].downcase
            routing.halt 400 unless (gh_url.include? 'github.com') &&
                                    (gh_url.split('/').count >= 3)
            owner_name, project_name = gh_url.split('/')[-2..]

            # Get project from Github
            project = Github::ProjectMapper
              .new(App.config.GITHUB_TOKEN)
              .find(owner_name, project_name)

            # Add project to database
            Repository::For.entity(project).create(project)

            # Redirect viewer to project page
            routing.redirect "project/#{project.owner.username}/#{project.name}"
          end
        end

        routing.on String, String do |owner_name, project_name|
          # GET /project/{owner_name}/{project_name}
          routing.get do
            # Get project from database
            project = Repository::For.klass(Entity::Project)
              .find_full_name(owner_name, project_name)

            # Show viewer the project
            view 'project', locals: { project: project }
          end
        end
      end
    end
  end
end
