// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('turbo:before-stream-render', function(event) {
  const elementToRemove = document.getElementById(event.target.target)

  if(elementToRemove) {
    const exitClass = elementToRemove.dataset.exitAnimationClass;
    if(exitClass) {
      event.preventDefault();
      elementToRemove.classList.add(exitClass);
      elementToRemove.addEventListener('animationend', () => {
        event.target.performAction();
      });
    }
  }
});
