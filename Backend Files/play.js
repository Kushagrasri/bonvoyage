//console.log(Math.floor( Math.random() * (99999 - 10000) + 10000))

var today = new Date();
var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
var dateTime = date+' '+time;

//console.log(dateTime)

var g1 = new Date(); 
console.log(g1.getTime())