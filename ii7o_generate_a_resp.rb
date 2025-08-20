require 'sinatra'
require 'json'
require 'rest-client'

# API endpoint to generate a responsive DevOps pipeline integrator

class II7O < Sinatra::Base
  post '/generate_pipeline' do
    # Get request body
    request_body = JSON.parse(request.body.read)

    # Validate request body
    if request_body['pipeline_name'].nil? || request_body['pipeline_type'].nil?
      status 400
      body 'Missing pipeline name or type'
    end

    # Generate pipeline based on type
    case request_body['pipeline_type']
    when 'jenkins'
      pipeline_config = generate_jenkins_pipeline(request_body['pipeline_name'])
    when 'gitlab'
      pipeline_config = generate_gitlab_pipeline(request_body['pipeline_name'])
    else
      status 400
      body 'Unsupported pipeline type'
    end

    # Return pipeline config
    headers 'Content-Type' => 'application/json'
    JSON.generate(pipeline_config)
  end

  private

  def generate_jenkins_pipeline(pipeline_name)
    {
      'pipeline' => {
        'name' => pipeline_name,
        'stages' => [
          {
            'stage' => 'build',
            'steps' => [
              {
                'step' => 'git checkout'
              },
              {
                'step' => 'mvn package'
              }
            ]
          },
          {
            'stage' => 'deploy',
            'steps' => [
              {
                'step' => 'deploy to prod'
              }
            ]
          }
        ]
      }
    }
  end

  def generate_gitlab_pipeline(pipeline_name)
    {
      'pipeline' => {
        'name' => pipeline_name,
        'stages' => [
          {
            'stage' => 'build',
            'script' => [
              'git checkout',
              'mvn package'
            ]
          },
          {
            'stage' => 'deploy',
            'script' => [
              'deploy to prod'
            ]
          }
        ]
      }
    }
  end
end