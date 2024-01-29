export const formatDate = (dateString) => {
  try {
    return new Date(dateString).toLocaleDateString('en-us', {
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
  try {
    return new Date(dateString).toLocaleTimeString('en-us', { hour: 'numeric', minute: '2-digit' });
  } catch {
    return 'Invalid date';
  }
};

export const extractMapPlace = (url) => {
  const regex = /.+place\/(.+?)\//i;
  return url.match(regex)[1];
};
