AUTH_TOKEN = $('meta[name=csrf-token]').attr('content')

window.Api =
  get: (url) ->
    this.ajax 'GET', url
  put: (url, data) ->
    this.ajax 'PUT', url, data
  post: (url, data) ->
    this.ajax 'POST', url, data
  delete: (url) ->
    this.ajax 'DELETE', url
  ajax: (method, url, data) ->
    config = {
      url: url
      method: method
    }
    config.data = data if data
    $.ajax(
      url: url,
      data: data,
      method: method,
    ).fail(this._onError)
  _onError: (jqXHR) ->
    message = if jqXHR.responseJSON && jqXHR.responseJSON.error
      jqXHR.responseJSON.error
    else
      "#{jqXHR.status} - #{jqXHR.statusText}"
    UIkit.notification message, 'danger'

getTodoListId = (element) ->
  element.find('.todo-list').data 'todo-list-id'

updateSortOrder = (element) ->
  data = {
    authenticity_token: AUTH_TOKEN
  }
  id = getTodoListId $(element)
  data.after = getTodoListId $(element).prev()
  todoListSection = $(element).parents('.todo-list-section')
  if todoListSection
    plannedAt = todoListSection.find('> header time').attr('datetime')
    data.plannedAt = if plannedAt
      date = new Date plannedAt
      date.setHours 18
      date.toISOString()
    else
      null
  Api.put "/todos/#{id}/sort.json", data

document.addEventListener 'turbolinks:load', ->
  $('.todo-lists').on 'change', (event, sortable, movedElements) ->
    for element in movedElements
      newSortable = $(element).parents('.todo-lists')[0]
      # only act on the move to event
      if newSortable == sortable.$el[0]
        updateSortOrder element
