require_relative 'starter_service'

class Demo

  def call(_env)
    @html = ''
    #TODO
    [ 200, { 'Content-Type' => 'text/html' }, [ @html ] ]
  end

  private

  # - - - - - - - - - - - - - - - - - - - - -

  def ragger
    RaggerService.new
  end

  def timed
    started = Time.now
    yield
    finished = Time.now
    '%.2f' % (finished - started)
  end

  def pre(name, duration, colour = 'white', quad = nil)
    border = 'border: 1px solid black;'
    padding = 'padding: 5px;'
    margin = 'margin-left: 30px; margin-right: 30px;'
    background = "background: #{colour};"
    whitespace = "white-space: pre-wrap;"
    html = "<pre>/#{name}(#{duration}s)</pre>"
    unless quad.nil?
      html += "<pre style='#{whitespace}#{margin}#{border}#{padding}#{background}'>" +
              "#{JSON.pretty_unparse(quad)}" +
              '</pre>'
    end
    html
  end

end
