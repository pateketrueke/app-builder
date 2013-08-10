class App.ractiveWidget

  constructor: (context) ->
    { @partial } = context

  render: (params) ->

    current_user = 1

    view = new Ractive
      el: '#sample-out'
      template: @partial 'ractive'
      sanitize: on
      data:
        users: params.list
        selected: current_user
        current_user: params.list[current_user]

    view.on
      set_user: (e) ->
        current_user = parseInt(e.node.value, 10)

        view.set
          selected: current_user
          current_user: params.list[current_user]

    view
