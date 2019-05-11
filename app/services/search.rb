class Services::Search
  SEARCH_TYPES = { 'вопросы' => Question, 'комментарии' => Comment, 'ответы' => Answer, 'пользователи' => User,
                   'все' => ThinkingSphinx }.freeze

  def self.search_result(search_type, search_query)
    search_type.constantize.search(search_query)
  end
end