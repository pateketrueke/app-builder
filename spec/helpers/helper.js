var root = this || window;

root.context = root.describe;
root.xcontext = root.xdescribe;
root._$blanket = root._$jscoverage;

if (! document.body) {
  document.body = document.createElement('body');
  document.getElementsByTagName('html')[0].appendChild(document.body);
}
