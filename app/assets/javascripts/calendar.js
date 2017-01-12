$(document).ready(function () {

  var open_event;

  var $dialog = $('#view-dialog').dialog({
    autoOpen: false,
    buttons: {
      'Duplicar': function () {
        duplicate_event(open_event);
        $(this).dialog("close");
      },
      'Apagar': function () {
        destroy_event(open_event);
        $(this).dialog("close");
      }
    }
  });

  $("#projects").fancytree({
    extensions: ["dnd", "persist", "filter"],
    quicksearch: true,
    source: {
      url: "/api/projects/open",
      cache: false
    },
    dnd: {
      smartRevert: false,    // set draggable.revert = true if drop was rejected
      draggable: {
        zIndex: 999,
        appendTo: "body",
        helper: draggable_helper
      },
      dragStart: function () {
        return true;
      }
    }
  });

  $("#projects-recents").fancytree({
    extensions: ["dnd", "persist"],
    source: {
      url: "/api/projects/recents",
      cache: false
    },
    dnd: {
      smartRevert: false,    // set draggable.revert = true if drop was rejected
      draggable: {
        zIndex: 999,
        appendTo: "body",
        helper: draggable_helper
      },
      dragStart: function () {
        return true;
      }
    }
  });

  $("#projects-closed").fancytree({
    extensions: ["dnd", "filter"],
    source: {
      url: "/api/projects/closed",
      cache: false
    },
    dnd: {
      smartRevert: false,    // set draggable.revert = true if drop was rejected
      draggable: {
        zIndex: 999,
        appendTo: "body",
        helper: draggable_helper
      },
      dragStart: function () {
        return true;
      }
    }
  });

  function draggable_helper(event) {
    var sourceNode = $.ui.fancytree.getNode(event.target);

    // Copy description to title because Fancytree already use title and Fullcalendar needs it
    sourceNode.data.title = sourceNode.data.description;

    // Set event data to container because drop source is the container instead of node
    $(event.currentTarget).data('event', sourceNode.data);

    var $helper =
      $('<div class="drag-helper">' +
        '  <div class="fc-time-grid-event fc-v-event fc-event">' +
        '    <div class="fc-content">' +
        '      <div class="fc-title">' + sourceNode.data.description + '</div>' +
        '    </div>' +
        '    <div class="fc-bg"></div>' +
        '   </div>' +
        '</div>');

    if (sourceNode.data.cor) {
      $helper.find('.fc-event').css({
        backgroundColor: sourceNode.data.color
      });
    }

    // Attach node reference to helper object
    $helper.data("ftSourceNode", sourceNode);

    // we return an unconnected element, so `draggable` will add this
    // to the parent specified as `appendTo` option
    return $helper;
  }

  var $calendar = $('#calendar').fullCalendar({
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'agendaWeek,month'
    },
    height: $(window).height() - $('.navbar').outerHeight(true),
    defaultView: 'agendaWeek',
    nowIndicator: true,
    allDaySlot: false,
    locale: 'pt-br',
    timeFormat: 'H:mm',
    slotLabelFormat: 'H:mm',
    slotLabelInterval: '01:00:00',
    slotDuration: '00:15:00',
    snapDuration: '00:15:00',
    defaultTimedEventDuration: '01:00:00',
    editable: true,
    droppable: true,
    forceEventDuration: true,
    events: '/api/tasks',
    eventResize: function (event) {
      $calendar.trigger('busycal.event_update', [event]);
    },
    eventDrop: function (event) {
      $calendar.trigger('busycal.event_update', [event]);
    },
    eventReceive: function (event) {
      event.stored = false;
      $calendar.trigger('busycal.event_create', [event]);
    },
    eventClick: function (event) {
      open_event = event;

      $dialog.find('.view-dialog-project span').text(event.project);
      $dialog.find('.view-dialog-subproject span').text(event.subproject);
      $dialog.find('.view-dialog-phase span').text(event.phase);
      $dialog.find('.view-dialog-client span').text(event.client);

      $dialog.dialog('open');
    }
  });

  $calendar.on('busycal.event_create', function (e, event) {
    create_task_api(event);
  });

  $calendar.on('busycal.event_created', function (e, event) {

  });

  $calendar.on('busycal.event_update', function (_e, _event) {
    var event = _event;
    if (event.stored) {
      update_task_api(event);
    } else {
      if (typeof event.timeout !== 'undefined') {
        clearTimeout(event.timeout);
      }

      event.timeout = setTimeout(function () {
        $calendar.trigger('busycal.event_update', [event]);
      }, 1000);
    }
  });

  $calendar.on('busycal.event_destroy', function (_e, _event) {
    var event = _event;
    if (event.stored) {
      destroy_task_api(event);
    } else {
      if (typeof event.timeout !== 'undefined') {
        clearTimeout(event.timeout);
      }

      event.timeout = setTimeout(function () {
        $calendar.trigger('busycal.event_destroy', [event]);
      }, 1000);
    }
  });

  function create_task_api(_event) {
    var event = _event;
    $.ajax({
      url: '/api/tasks',
      type: 'post',
      data: {
        subproject_phase_id: event.subproject_phase_id,
        start: event.start.format(),
        end: event.end.format()
      },
      success: function (data) {
        event.id = data.task.id;
        event.stored = true;
        $calendar.trigger('busycal.event_created', [event])
      }
    });
  }

  function update_task_api(_event) {
    var event = _event;
    $.ajax({
      url: '/api/tasks/' + event.id,
      type: 'patch',
      data: {
        start: event.start.format(),
        end: event.end.format(),
        request_control: new Date().getTime()
      },
      success: function (data) {
        $calendar.trigger('busycal.event_updated', [event, data])
      }
    });
  }

  function destroy_task_api(_event) {
    var event = _event;
    $.ajax({
      url: '/api/tasks/' + event.id,
      type: 'delete',
      success: function (data) {
        $calendar.trigger('busycal.event_destroyed', [event, data])
      }
    });
  }

  function destroy_event(event) {
    $calendar.fullCalendar('removeEvents', event._id);
    $calendar.trigger('busycal.event_destroy', [event])
  }

  function duplicate_event(event) {
    var clone = {
      title: "Clone",
      client: event.client,
      phase: event.phase,
      subproject: event.subproject,
      project: event.project,
      subproject_phase_id: event.subproject_phase_id,
      stored: false,
      color: event.color,
      start: event.start,
      end: event.end,
      allDay: false
    };

    var created_event = $calendar.fullCalendar('renderEvent', clone, false);
    $calendar.trigger('busycal.event_create', [created_event[0]]);
  }
});
