// Called by calculator.js after every "=" press
window.saveCalculation = function (expression, result, angle) {
  var body = new URLSearchParams({ expression: expression, result: result, angle: angle });
  var token = document.querySelector('meta[name="csrf-token"]');
  fetch("saveCalculation", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded", "X-CSRF-Token": token ? token.content : "" },
    body: body
  }).catch(function () { /* saving is best-effort; the calculator keeps working */ });
};
