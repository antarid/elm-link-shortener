const fullLink1 = 'https://google.com';
const fullLink2 = 'https://onliner.by';

it('whole workflow', () => {
  cy.server();
  cy.route({ url: 'https://api-ssl.bitly.com/v4/shorten', method: 'POST' }).as('generateLink');

  cy.visit('/');

  cy.findByTestId('link-input').type(fullLink1);
  cy.findByTestId('generate-link-button').click();

  cy.wait('@generateLink');

  cy.findByTestId('shortened-link').should('exist').and('be.not.empty');

  cy.findByTestId('link-input').type(fullLink2);

  cy.findByTestId('change-mode-button').click();

  cy.findByText(fullLink1).should('exist');
  cy.findByText(fullLink2).should('not.exist');

  cy.findByTestId('change-mode-button').click();
  cy.findByTestId('link-input').should('have.value', fullLink2);

  cy.findByTestId('generate-link-button').click();

  cy.wait('@generateLink');

  cy.findByTestId('change-mode-button').click();

  [fullLink1, fullLink2].forEach((link) =>
    cy.findByText(link).parent().find('a').should('exist').and('be.not.empty')
  );
});
