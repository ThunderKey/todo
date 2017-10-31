getTodoListId = (element) ->
  element.find('.todo-list').data 'todo-list-id'

updateSortOrder = (element) ->
      id = getTodoListId $(element)
      previousId = getTodoListId $(element).prev()
      $.ajax(
        url: "/todos/#{id}/sort.json",
        data: {
          after: previousId,
          authenticity_token: $('meta[name=csrf-token]').attr('content'),
        },
        method: 'PUT',
      ).fail(-> UIkit.notification 'Could not sort', 'danger')

document.addEventListener 'turbolinks:load', ->
  $('#todo-lists').on 'change', (event, sortable, movedElements) ->
    updateSortOrder(element) for element in movedElements
