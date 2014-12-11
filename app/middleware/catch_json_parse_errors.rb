class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue ActionDispatch::ParamsParser::ParseError => error
      if env['CONTENT_TYPE'] == 'application/json'
        return [
          400, { "Content-Type" => "application/json" },
          [ { message: "Problems parsing JSON" }.to_json ]
        ]
      else
        raise error
      end
    end
  end
end
