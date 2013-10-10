var root = this || window;

root.context = root.describe;
root.xcontext = root.xdescribe;

root._$blanket = root._$jscoverage = {};

if (! document.body) {
  document.body = document.createElement('body');
  document.getElementsByTagName('html')[0].appendChild(document.body);
}

root.delay = function (resume, callback) {
  setTimeout(function () {
    callback();
    resume();
  }, 260);
};

root.alert = (function () {
  var tmp = [];

  return function (str) {
    if (0 === arguments.length) {
      return tmp;
    }

    tmp.push(str);

    return str;
  };
}());
