require_relative 'custom_service'
require_relative 'exercises_service'
require_relative 'languages_service'

class Demo

  def call(_env)
    c_name = 'Yahtzee refactoring, Java JUnit'
    e_name = 'Tiny Maze'
    l_name = 'C#, NUnit'

    html = [
      pre('   custom.sha()') {    custom.sha },
      pre('exercises.sha()') { exercises.sha },
      pre('languages.sha()') { languages.sha },

      pre('   custom.ready?()') {    custom.ready? },
      pre('exercises.ready?()') { exercises.ready? },
      pre('languages.ready?()') { languages.ready? },

      pre('   custom.names()') {    custom.names },
      pre('exercises.names()') { exercises.names },
      pre('languages.names()') { languages.names },

      pre('   custom.manifests()') {    custom.manifests },
      pre('exercises.manifests()') { exercises.manifests },
      pre('languages.manifests()') { languages.manifests },

      pre("   custom.manifest(#{c_name})") {    custom.manifest(c_name) },
      pre("exercises.manifest(#{e_name})") { exercises.manifest(e_name) },
      pre("languages.manifest(#{l_name})") { languages.manifest(l_name) },

      pre('   custom.wibble()') {    custom.wibble },
      pre('exercises.wibble()') { exercises.wibble },
      pre('languages.wibble()') { languages.wibble }

    ].join
    [ 200, { 'Content-Type' => 'text/html' }, [ html ] ]
  end

  # - - - - - - - - - - - - - - - - -

  def custom
    CustomService.new
  end

  def exercises
    ExercisesService.new
  end

  def languages
    LanguagesService.new
  end

  def timed
    started = Time.now
    result = yield
    finished = Time.now
    duration = '%.4f' % (finished - started)
    [result,duration]
  end

  # - - - - - - - - - - - - - - - - -

  def pre(name, &block)
    result,duration = *timed {
      begin
        block.call
      rescue => error
        JSON.parse(error.message)
      end
    }
    [
      "<pre>/#{name.strip}[#{duration}s]</pre>",
      "<pre style='#{style}'>",
        "#{JSON.pretty_unparse(result)}",
      '</pre>'
    ].join
  end

  def style
    [whitespace,margin,border,padding,background].join
  end

  def border
    'border: 1px solid black;'
  end

  def padding
    'padding: 10px;'
  end

  def margin
    'margin-left: 30px; margin-right: 30px;'
  end

  def background
    'background: white;'
  end

  def whitespace
    'white-space: pre-wrap;'
  end

end
