var root = this || window;

root.context = root.describe;
root.xcontext = root.xdescribe;

root._$blanket = root._$jscoverage;

root.delay = function (resume, callback) {
  setTimeout(function () {
    callback();
    resume();
  }, 260);
};
