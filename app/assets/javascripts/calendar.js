$(document).ready(function () {

  $('.select2').select2({
    theme: "bootstrap"
  });

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

  $('.js-tree').each(function () {
    var $container = $(this);
    var $tree_content = $container.find('.tree-content');
    var $input = $container.find('.tree-filter');
    var tree;

    $tree_content.fancytree({
      extensions: ["dnd", "persist", "filter"],
      quicksearch: true,
      clickFolderMode: 2,
      focusOnSelect: false,
      selectMode: 1,
      create: function(){
        $container.find(".fancytree-container").addClass("fancytree-connectors");
      },
      source: {
        url: $container.data('tree-source'),
        cache: false
      },
      persist: {
        overrideSource: true,
        cookiePrefix: 'fancytree-' + $container.data('tree-name') + '-',
        store: "cookie",     // 'cookie': use cookie, 'local': use localStore, 'session': use sessionStore
        types: "active expanded focus selected"  // which status types to store
      },
      dnd: {
        smartRevert: false,
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

    tree = $tree_content.fancytree("getTree");

    if($input.length > 0) {
      $input.keyup(function (e) {
        var match = $(this).val();

        if(e && e.which === $.ui.keyCode.ESCAPE || $.trim(match) === ""){
          tree.clearFilter();
          $input.val('');
          return;
        }

        tree.filterBranches.call(tree, match, {
          autoApply: true,
          autoExpand: true,
          counter: false,
          fuzzy: true,
          hideExpanders: true,
          highlight: true,
          nodata: true,
          mode: 'hide'
        });
        // $("button#btnResetSearch").attr("disabled", false);
        // $("span#matches").text("(" + n + " matches)");
      });
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
    events: {
      url: '/api/tasks',
      data: {
        user_id: app.user_id
      }
    },
    eventResize: function (_event) {
      var event = _event;
      setTimeout(function(){
        $('.fc-event').each(function(){
          if($(this).data('fcSeg').event.id == event.id) {
            $(this).css('opacity', 0.5);
          }
        });
      }, 10);
      $calendar.trigger('busycal.event_update', [event]);
    },
    eventDrop: function (_event) {
      var event = _event;
      setTimeout(function(){
        $('.fc-event').each(function(){
          if($(this).data('fcSeg').event.id == event.id) {
            $(this).css('opacity', 0.5);
          }
        });
      }, 10);
      $calendar.trigger('busycal.event_update', [event]);
    },
    eventReceive: function (event) {
      event.stored = false;
      $('.fc-event').each(function(){
        if($(this).data('fcSeg').event.id == event.id) {
          $(this).css('opacity', 0.5);
        }
      });

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

  $(window).resize(function(){
    $calendar.fullCalendar('option', 'height', $(window).height() - $('.navbar').outerHeight(true));
  });

  $calendar.on('busycal.event_create', function (e, event) {
    create_task_api(event);
  });

  $calendar.on('busycal.event_created', function (e, event) {
    $('.fc-event').each(function(){
      if($(this).data('fcSeg').event.id == event.id) {
        $(this).css('opacity', 1);
      }
    });
  });

  $calendar.on('busycal.event_updated', function (e, event) {
    $('.fc-event').each(function(){
      if($(this).data('fcSeg').event.id == event.id) {
        $(this).css('opacity', 1);
      }
    });
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
        end: event.end.format(),
        user_id: app.user_id
      },
      success: function (data) {
        event.id = data.task.id;
        event.stored = true;
        $calendar.trigger('busycal.event_created', [event])
      },
      error: function(jqXHR, textStatus, errorThrown) {
        if(jqXHR.status == 403) {
          location.reload();
        } else {
          alert('Erro ao salvar!!!');
          location.reload();
        }
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
        request_control: new Date().getTime(),
        user_id: app.user_id
      },
      success: function (data) {
        $calendar.trigger('busycal.event_updated', [event, data])
      },
      error: function(jqXHR, textStatus, errorThrown) {
        if(jqXHR.status == 403) {
          location.reload();
        } else {
          alert('Erro ao salvar!!!');
          location.reload();
        }
      }
    });
  }

  function destroy_task_api(_event) {
    var event = _event;
    $.ajax({
      url: '/api/tasks/' + event.id,
      type: 'delete',
      data: {
        user_id: app.user_id
      },
      success: function (data) {
        $calendar.trigger('busycal.event_destroyed', [event, data])
      },
      error: function(jqXHR, textStatus, errorThrown) {
        if(jqXHR.status == 403) {
          location.reload();
        }
      }
    });
  }

  function destroy_event(event) {
    $calendar.fullCalendar('removeEvents', event._id);
    $calendar.trigger('busycal.event_destroy', [event])
  }

  function duplicate_event(event) {
    var clone = {
      title: event.title,
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
