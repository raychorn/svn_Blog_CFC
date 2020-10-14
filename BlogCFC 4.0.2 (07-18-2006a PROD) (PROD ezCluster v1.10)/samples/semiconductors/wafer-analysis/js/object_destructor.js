// object_destructor.js

function object_destructor(oO) { var rV = -1; try { rV = oO.destructor(); } catch(e) { rV = null; } finally { rV = null; }; return rV; }

