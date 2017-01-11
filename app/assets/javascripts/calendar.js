$(document).ready(function () {

  $("#projects").fancytree({
    create: function() {
      console.log('treeCreate');
      enable_phases_drag();
    }
  });
  // $('#projects').on('init.jstree', function () {
  //   enable_phases_drag();
  // }).jstree({
  //   core: {
  //     multiple: false
  //   }
  // });

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
    eventReceive: function (_event) {
      var event = _event;
      event.stored = false;
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

  $calendar.on('busycal.event_updated', function (_e, event, data) {

  });

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


  function enable_phases_drag() {
    $('.js-phases').each(function () {
      // store data so the calendar knows to render an event upon drop
      $(this).data('event', {
        title: $.trim($(this).text()),
        subproject_phase_id: $(this).data('subproject-phase-id'),
        event_id: null
      });

      // make the event draggable using jQuery UI
      $(this).draggable({
        cursor: "move",
        zIndex: 999,
        revert: true,
        revertDuration: 0,
        helper: function (event) {
          var data = $(event.currentTarget).data('event');

          var html =
            '<div class="drag-helper fc fc-ltr ui-widget">' +
            '<div class="fc-event fc-event-vert fc-event-draggable fc-event-start fc-event-end ui-draggable ui-resizable">' +
            '<div class="fc-event-inner">' +
            '<div class="fc-event-time">&nbsp;</div>' +
            '<div class="fc-event-title">' +
            data.title +
            '</div>' +
            '</div>' +
            '<div class="fc-event-bg"></div>' +
            '<div class="ui-resizable-handle ui-resizable-s">=</div>' +
            '</div>' +
            '</div>';

          if (data.cor) {
            html = $(html).find('.fc-event').css('background-color', '#' + data.cor).css('border-color', '#' + data.cor_borda).end();
          } else {
            html = $(html);
          }

          return html;
        }
      });
    });
  }
});