class QuestionServiceFacade
  def self.get_questions(game)
    number = game.number_of_questions
    topic = game.topic

    service_response = QuestionService.new(number, topic).call

    # temp fix to check other features until questions service fixed, this can't stay
    service_response = File.read("spec/fixtures/question_service_2.json")

    parse_questions(service_response).map do |question_data|
      Question.new(question_data)
    end
  end

  def self.parse_questions(service_response)
    response = JSON.parse(service_response)
    questions = response["choices"].first["message"]["content"]
    
    parsed_data = []

    questions.split("```json\n").reject(&:empty?).map do |json_string|
      parsed_data << JSON.parse(json_string.gsub("```", ""))
    end
    parsed_data
  end
end