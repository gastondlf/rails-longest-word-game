// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

console.log("i am here");

const letter = document.querySelectorAll(".letter");

letter.forEach((letter) => {
    letter.addEventListener("click", (event) => {
        console.log("clicked");
    });    
});