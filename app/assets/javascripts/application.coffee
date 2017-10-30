# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
# vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require rails-ujs
#= require jquery
#= require uikit/uikit
#= require uikit/uikit-icons
#= require turbolinks
#= require_self

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
      ).fail(-> alert 'Could not sort!')

document.addEventListener 'turbolinks:load', ->
  $('#todo-lists').on 'change', (event, sortable, movedElements) ->
    updateSortOrder(element) for element in movedElements
