const linkElementId = 'generated-link';

export const showLink = (link) => {
  hideLink(); // remove already existing link

  const newLinkElement = document.createElement('a');
  newLinkElement.href = link;
  newLinkElement.innerHTML = link;
  newLinkElement.target = '_blank';
  newLinkElement.id = linkElementId;

  document.getElementById('elm-container').appendChild(newLinkElement);
};

export const hideLink = () => {
  const linkElement = document.getElementById(linkElementId);
  if (linkElement) document.getElementById('elm-container').removeChild(linkElement);
};
