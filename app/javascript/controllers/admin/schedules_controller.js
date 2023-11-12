/* eslint-disable no-underscore-dangle */
/* eslint-disable no-plusplus */
import { Controller } from '@hotwired/stimulus';
import { Calendar } from '@fullcalendar/core';
import resourceTimelineDay from '@fullcalendar/resource-timeline';
import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';

import Pickr from '@simonwep/pickr';
import '@simonwep/pickr/dist/themes/classic.min.css';

const paireResources = (resources) => {
  const result = resources.map((resource) => ({
    id: resource.id,
    title: resource.title,
    avatar: resource.avatar,
  }));

  return result;
};

const defaultOptions = {
  timeZone: 'UTC',
  headerToolbar: false,
  aspectRatio: 1.5,
  resourceAreaWidth: '20%',
  slotDuration: '00:30:00',
  slotLabelInterval: '00:30',
  slotMinTime: '08:00',
  slotMaxTime: '21:30',
  slotLabelFormat: {
    hour: 'numeric',
    minute: '2-digit',
    omitZeroMinute: false,
  },
  displayEventTime: false,
  editable: true,
};

const paireEvents = (events) => {
  const result = events.map((event) => ({
    id: event.id,
    resourceId: event.resource_id,
    title: event.title,
    start: event.start,
    end: event.end,
    className: event.class_name,
    textColor: event.text_color,
    subtitle: event.subtitle,
    backgroundColor: event.color,
    borderColor: event.border_color,
    courseId: event.course_id,
  }));

  return result;
};

const eventContent = (arg) => {
  const titleEl = document.createElement('p');
  const timeEl = document.createElement('span');

  titleEl.innerHTML = arg.event.title;
  timeEl.innerHTML = arg.event.extendedProps.subtitle;
  titleEl.classList.add('event-title');
  timeEl.classList.add('event-time');

  const arrayOfDomNodes = [titleEl, timeEl];
  return arrayOfDomNodes;
};

const resourceLabelContent = (arg) => {
  const nameEl = document.createElement('b');
  const avatarEl = document.createElement('img');
  nameEl.innerHTML = arg.resource.title;
  avatarEl.src = arg.resource.extendedProps.avatar;
  avatarEl.classList.add('avatar');
  nameEl.classList.add('font-weight-700');
  nameEl.classList.add('text-wrap');

  const arrayOfDomNodes = [avatarEl, nameEl];
  return arrayOfDomNodes;
};

const renderFullCalendar = (calendarEl, res) => {
  const element = calendarEl;
  element.innerHTML = '';
  const option = {
    plugins: [resourceTimelineDay],
    initialView: 'resourceTimelineDay',
    resourceAreaHeaderContent: 'Teacher',
    resources: paireResources(res.resources),
    resourceLabelContent: (arg) => ({ domNodes: resourceLabelContent(arg) }),
    events: paireEvents(res.events),
    eventContent: (arg) => ({ domNodes: eventContent(arg) }),
    eventClick: (info) => {
      Turbolinks.visit(`classes/${info.event._def.extendedProps.courseId}`);
    },
  };

  const calendar = new Calendar(calendarEl, { ...defaultOptions, ...option });

  calendar.render();
  calendar.changeView('resourceTimelineDay', res.day);
};

const callApiCalendar = (props) => {
  const { day, subjectsTarget, dateTarget, calendarEl } = props;
  const formInputEls = subjectsTarget.querySelectorAll('.form-check-input');
  const arrSubjects = Array.from(formInputEls).map((el) =>
    el.checked ? el.value : '',
  );
  const subjectIds = arrSubjects.filter((e) => e);
  const url = `/admin/schedules?&subject_ids=${subjectIds.toString()}&day=${day}`;

  Rails.ajax({
    url,
    type: 'get',
    dataType: 'json',
    success: (res) => {
      renderFullCalendar(calendarEl, res);
      calendarEl.querySelector('.fc-license-message').style.display = 'none';
      dateTarget.dataset.day = res.day;
      dateTarget.innerHTML = res.day_string;
    },
  });
};

const rotateIcon = (target) => {
  const iconEl = target.currentTarget.querySelector('img');
  const { classList } = iconEl;
  const hideEl = iconEl.closest('div')?.querySelector('.text-blue');

  if (classList.value.includes('rotated')) {
    classList.remove('rotated');
    if (hideEl !== null) {
      hideEl.innerText = 'Hide';
    }
  } else {
    classList.add('rotated');
    if (hideEl !== null) {
      hideEl.innerText = 'Show';
    }
  }
};

const colorPickerOption = {
  el: '.color-picker-bg',
  theme: 'classic',
  useAsButton: true,
  swatches: [
    'rgba(244, 67, 54, 1)',
    'rgba(233, 30, 99, 0.95)',
    'rgba(156, 39, 176, 0.9)',
    'rgba(103, 58, 183, 0.85)',
    'rgba(63, 81, 181, 1)',
    'rgba(33, 150, 243, 1)',
    'rgba(3, 169, 244, 1)',
    'rgba(0, 188, 212, 1)',
    'rgba(0, 150, 136, 1)',
    'rgba(76, 175, 80, 1)',
    'rgba(139, 195, 74, 1)',
    'rgba(205, 220, 57, 1)',
    'rgba(255, 235, 59, 1)',
    'rgba(255, 193, 7, 1)',
  ],

  components: {
    // Main components
    preview: true,
    opacity: true,
    hue: true,

    interaction: {
      hex: true,
      rgba: false,
      hsla: false,
      hsva: false,
      cmyk: false,
      input: true,
      clear: false,
      save: true,
    },
  },
};

const listTeacherInfos = () => document.getElementById('list_teacher_infos');

const callApiGetTeacherInfo = (id, day) => {
  const url = `/admin/schedules/teacher_info?course_id=${id}&day=${day}`;
  const timeListcontainer = document.getElementById('timeListcontainer');
  listTeacherInfos()?.querySelector('.active')?.classList?.remove('active');

  Rails.ajax({
    url,
    type: 'get',
    dataType: 'json',
    success: (res) => {
      listTeacherInfos()
        .querySelector(`[data-teacher-id="${res.teacher_id}"]`)
        ?.remove();
      listTeacherInfos().innerHTML =
        res.html_teacher + listTeacherInfos().innerHTML;
      timeListcontainer.innerHTML = res.html_times;
    },
  });
};

const callApiGetSchedules = (courseId, teacherId, day) => {
  const url = `/admin/schedules/teacher_info?course_id=${courseId}&teacher_id=${teacherId}&day=${day}`;
  const timeListcontainer = document.getElementById('timeListcontainer');
  listTeacherInfos()?.querySelector('.active')?.classList?.remove('active');

  Rails.ajax({
    url,
    type: 'get',
    dataType: 'json',
    success: (res) => {
      listTeacherInfos()
        .querySelector(`[data-teacher-id="${res.teacher_id}"]`)
        ?.classList.add('active');
      timeListcontainer.innerHTML = res.html_times;
    },
  });
};

const renderModalSubjectForm = (event) => {
  const el = event.currentTarget;
  const modal = document.getElementById('modalCreateSubject');
  modal.innerHTML = '';
  Rails.ajax({
    url: el.dataset.url,
    type: 'get',
    dataType: 'json',
    success: (res) => {
      modal.innerHTML = res.html;
      const myModal = new bootstrap.Modal(modal, {});
      myModal.show();
    },
  });
};

export default class extends Controller {
  static targets = [
    'calendar',
    'date',
    'subjects',
    'prev',
    'next',
    'colorPicker',
    'course',
    'dateCanvas',
  ];

  connect() {
    callApiCalendar(this.paramsCallApiCalendar(''));
  }

  prevTime() {
    const date = new Date(this.dateTarget.dataset.day);
    date.setDate(date.getDate() - 1);
    const day = date.toISOString().split('T')[0];
    callApiCalendar(this.paramsCallApiCalendar(day));
    document.querySelector('#date-picker-input').setAttribute('value', day);
  }

  nextTime() {
    const date = new Date(this.dateTarget.dataset.day);
    date.setDate(date.getDate() + 1);
    const day = date.toISOString().split('T')[0];
    callApiCalendar(this.paramsCallApiCalendar(day));
    document.querySelector('#date-picker-input').setAttribute('value', day);
  }

  rotateIcon(target) {
    rotateIcon(target);
  }

  filterByDay(target) {
    callApiCalendar(this.paramsCallApiCalendar(target.currentTarget.value));
  }

  paramsCallApiCalendar = (day) => {
    const options = {
      day,
      subjectsTarget: this.subjectsTarget,
      calendarEl: this.calendarTarget,
      dateTarget: this.dateTarget,
    };

    return options;
  };

  setColorBackground() {
    const pickr = Pickr.create(colorPickerOption);

    pickr.on('save', (color) => {
      const colorSample = document.querySelector('#colorSample');
      const colorHex = `#${color.toHEXA().join('')}`;
      colorSample.style.backgroundColor = colorHex;
      pickr.hide();
      const bgColor = document.querySelector('#subject_color');
      bgColor.value = colorHex;
    });
  }

  setColorBorder() {
    const pickr = Pickr.create({
      ...colorPickerOption,
      ...{ el: '.color-picker-border' },
    });

    pickr.on('save', (color) => {
      const colorSample = document.querySelector('#colorSample');
      const borderColorHex = `#${color.toHEXA().join('')}`;
      colorSample.style.border = `1px solid ${borderColorHex}`;
      colorSample.style.borderLeft = `6px solid ${borderColorHex}`;
      pickr.hide();

      const bgColor = document.querySelector('#subject_border_color');
      bgColor.value = borderColorHex;
    });
  }

  submitSchedule(target) {
    const subjectNameEl = document.getElementById('subject_name');

    if (subjectNameEl.value) {
      const btnSubmit = target.currentTarget
        .closest('.modal-dialog')
        .querySelector('#btn-submit-subject');
      btnSubmit.click();
    } else {
      subjectNameEl.classList.add('is-invalid');
      document.getElementById('subject-name-feedback')?.remove();
      subjectNameEl.outerHTML += `<div class="invalid-feedback" id="subject-name-feedback">Name can't be blank</div>`;
    }
  }

  selectSubjectOffCanvas(target) {
    const id = target.currentTarget.querySelector('option').value;
    const url = `/admin/subjects/${id}/courses`;
    const classListCollectionEl = document.getElementById('classListComponent');

    Rails.ajax({
      url,
      type: 'get',
      dataType: 'json',
      success: (res) => {
        classListCollectionEl.innerHTML = res.html;
        classListCollectionEl
          .closest('.class-select-container')
          .classList.remove('d-none');
      },
    });
  }

  selectRadioTime(event) {
    const inputEl = event.currentTarget.querySelector('input');

    if (inputEl.checked) {
      event.currentTarget.classList.remove('fill-btn');
      inputEl.checked = false;
    } else {
      event.currentTarget.classList.add('fill-btn');
      inputEl.checked = true;
    }
  }

  selectClassOffCanvas(event) {
    const day = this.dateCanvasTarget.value;
    const courseId = event.currentTarget.querySelector('option').value;
    callApiGetTeacherInfo(courseId, day);
  }

  selectTeacher(event) {
    const courseId = this.courseTarget.querySelector('option')?.value;
    const { teacherId } = event.currentTarget.dataset;
    const day = this.dateCanvasTarget.value;

    if (courseId) {
      callApiGetSchedules(courseId, teacherId, day);
    } else {
      const timeListcontainer = document.getElementById('timeListcontainer');
      timeListcontainer.innerHTML = '';
    }
  }

  callFilterDay() {
    const courseId = this.courseTarget.querySelector('option')?.value;
    const teacherId =
      listTeacherInfos()?.querySelector('.active')?.dataset?.teacherId;
    const day = this.dateCanvasTarget.value;

    if (courseId) {
      callApiGetSchedules(courseId, teacherId, day);
    }
  }

  createSchedule() {
    const courseId = this.courseTarget.querySelector('option')?.value;
    const teacherId =
      listTeacherInfos()?.querySelector('.active')?.dataset?.teacherId;
    const timesEl = document.getElementById('timeListcontainer');
    const day = this.dateCanvasTarget.value;
    const inputsEl = timesEl.querySelectorAll('input');
    const arrChecked = Array.from(inputsEl)
      .filter((e) => e.checked)
      ?.map((e) => e.value);

    if (courseId && teacherId && arrChecked.length > 0) {
      const startTime = arrChecked.shift();
      let endTime = arrChecked.pop();

      if (endTime.split(':').pop() === '00') {
        endTime = `${endTime.split(':').shift()}:30`;
      } else if (endTime.split(':').pop() === '30') {
        endTime = `${parseInt(endTime.split(':').shift(), 10) + 1}:00`;
      }
      document.getElementById('schedule_course_id').value = courseId;
      document.getElementById('schedule_user_id').value = teacherId;
      document.getElementById('schedule_day').value = day;
      document.getElementById('schedule_start_time').value = startTime;
      document.getElementById('schedule_end_time').value = endTime;

      const arr = arrChecked.map((a) => a.split(':').shift());
      let resultArr = [];

      for (let i = 0; i < arr.lenght - 1; i++) {
        if (arr[i + 1] - arr[i] <= 1) {
          resultArr = [...resultArr, true];
        } else {
          resultArr = [...resultArr, false];
        }
      }

      if (resultArr.includes(false)) {
        document.getElementById('uninterruptedTimeError')?.remove();

        timesEl.innerHTML =
          this.messagesErrors('uninterrupted time', 'uninterruptedTimeError') +
          timesEl.innerHTML;
      } else {
        document.getElementById('btnSubmitCreateSchedule').click();
      }
    }

    if (!teacherId) {
      document.getElementById('teacherError')?.remove();
      timesEl.innerHTML =
        this.messagesErrors('teacher', 'teacherError') + timesEl.innerHTML;
    }

    if (!courseId) {
      document.getElementById('classError')?.remove();

      timesEl.innerHTML =
        this.messagesErrors('subject then select class', 'classError') +
        timesEl.innerHTML;
    }

    if (arrChecked.length === 0) {
      document.getElementById('periodTimesError')?.remove();
      timesEl.innerHTML =
        this.messagesErrors('period times', 'periodTimesError') +
        timesEl.innerHTML;
    }

    Array.from(timesEl.querySelectorAll('span')).forEach((e) => {
      if (Array.from(e.classList).includes('fill-btn')) {
        e.classList.remove('fill-btn');
      }
    });
  }

  messagesErrors(str, id) {
    const className =
      'text-danger font-size-16 font-weight-700 text-center message-schedule-form-error';
    const el = `<p class="${className}" id="${id}">- Please select ${str}</p>`;
    return el;
  }

  setDatasetSubject(event) {
    const btnDelete = document.querySelector('#delete-subject-btn');
    btnDelete.setAttribute('data-url', event.currentTarget.dataset.url);
    btnDelete.setAttribute(
      'data-subject-id',
      event.currentTarget.dataset.subjectId,
    );
  }

  removeSubject(event) {
    Rails.ajax({
      url: event.currentTarget.dataset.url,
      type: 'delete',
      dataType: 'json',
      success: (res) => {
        document.getElementById('flash').innerHTML = res.html_flash;
        document.getElementById(event.target.dataset.subjectId).remove();
      },
    });
  }

  setDatasetSubjectForm(event) {
    renderModalSubjectForm(event);
  }

  selectSubjects() {
    const date = new Date(this.dateTarget.dataset.day);
    callApiCalendar(this.paramsCallApiCalendar(date));
  }
}
