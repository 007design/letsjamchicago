export const formatDate = (dateString) => {
  const timezoneOffset = new Date().getTimezoneOffset() / 60;
  const timezoneString = `${timezoneOffset > 0 ? '-' : '+'}${(`0${timezoneOffset}`).slice(-2)}:00`;

  try {
    return new Date(dateString.replace(/Z$/, timezoneString)).toLocaleDateString('en-us', {
      weekday: 'long',
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      timeZone: 'America/Chicago',
    });
  } catch {
    return 'Invalid date';
  }
};

export const formatTime = (dateString) => {
  const timezoneOffset = new Date().getTimezoneOffset() / 60;
  const timezoneString = `${timezoneOffset > 0 ? '-' : '+'}${(`0${timezoneOffset}`).slice(-2)}:00`;

  try {
    return new Date(dateString.replace(/Z$/, timezoneString)).toLocaleTimeString('en-us', { hour: 'numeric', minute: '2-digit' });
  } catch {
    return 'Invalid date';
  }
};

export const extractMapPlace = (url) => {
  const regex = /.+place\/(.+?)\//i;
  return url.match(regex)[1];
};
