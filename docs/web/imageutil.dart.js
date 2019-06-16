{}(function dartProgram(){function copyProperties(a,b){var u=Object.keys(a)
for(var t=0;t<u.length;t++){var s=u[t]
b[s]=a[s]}}var z=function(){var u=function(){}
u.prototype={p:{}}
var t=new u()
if(!(t.__proto__&&t.__proto__.p===u.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var s=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(s))return true}}catch(r){}return false}()
function setFunctionNamesIfNecessary(a){function t(){};if(typeof t.name=="string")return
for(var u=0;u<a.length;u++){var t=a[u]
var s=Object.keys(t)
for(var r=0;r<s.length;r++){var q=s[r]
var p=t[q]
if(typeof p=='function')p.name=q}}}function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){a.prototype.__proto__=b.prototype
return}var u=Object.create(b.prototype)
copyProperties(a.prototype,u)
a.prototype=u}}function inheritMany(a,b){for(var u=0;u<b.length;u++)inherit(b[u],a)}function mixin(a,b){copyProperties(b.prototype,a.prototype)
a.prototype.constructor=a}function lazy(a,b,c,d){var u=a
a[b]=u
a[c]=function(){a[c]=function(){H.dz(b)}
var t
var s=d
try{if(a[b]===u){t=a[b]=s
t=a[b]=d()}else t=a[b]}finally{if(t===s)a[b]=null
a[c]=function(){return this[b]}}return t}}function makeConstList(a){a.immutable$list=Array
a.fixed$length=Array
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var u=0;u<a.length;++u)convertToFastObject(a[u])}var y=0
function tearOffGetter(a,b,c,d,e){return e?new Function("funcs","applyTrampolineIndex","reflectionInfo","name","H","c","return function tearOff_"+d+y+++"(receiver) {"+"if (c === null) c = "+"H.bT"+"("+"this, funcs, applyTrampolineIndex, reflectionInfo, false, true, name);"+"return new c(this, funcs[0], receiver, name);"+"}")(a,b,c,d,H,null):new Function("funcs","applyTrampolineIndex","reflectionInfo","name","H","c","return function tearOff_"+d+y+++"() {"+"if (c === null) c = "+"H.bT"+"("+"this, funcs, applyTrampolineIndex, reflectionInfo, false, false, name);"+"return new c(this, funcs[0], null, name);"+"}")(a,b,c,d,H,null)}function tearOff(a,b,c,d,e,f){var u=null
return d?function(){if(u===null)u=H.bT(this,a,b,c,true,false,e).prototype
return u}:tearOffGetter(a,b,c,e,f)}var x=0
function installTearOff(a,b,c,d,e,f,g,h,i,j){var u=[]
for(var t=0;t<h.length;t++){var s=h[t]
if(typeof s=='string')s=a[s]
s.$callName=g[t]
u.push(s)}var s=u[0]
s.$R=e
s.$D=f
var r=i
if(typeof r=="number")r=r+x
var q=h[0]
s.$stubName=q
var p=tearOff(u,j||0,r,c,q,d)
a[b]=p
if(c)s.$tearOff=p}function installStaticTearOff(a,b,c,d,e,f,g,h){return installTearOff(a,b,true,false,c,d,e,f,g,h)}function installInstanceTearOff(a,b,c,d,e,f,g,h,i){return installTearOff(a,b,false,c,d,e,f,g,h,i)}function setOrUpdateInterceptorsByTag(a){var u=v.interceptorsByTag
if(!u){v.interceptorsByTag=a
return}copyProperties(a,u)}function setOrUpdateLeafTags(a){var u=v.leafTags
if(!u){v.leafTags=a
return}copyProperties(a,u)}function updateTypes(a){var u=v.types
var t=u.length
u.push.apply(u,a)
return t}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var u=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e)}},t=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixin,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:u(0,0,null,["$0"],0),_instance_1u:u(0,1,null,["$1"],0),_instance_2u:u(0,2,null,["$2"],0),_instance_0i:u(1,0,null,["$0"],0),_instance_1i:u(1,1,null,["$1"],0),_instance_2i:u(1,2,null,["$2"],0),_static_0:t(0,null,["$0"],0),_static_1:t(1,null,["$1"],0),_static_2:t(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,updateHolder:updateHolder,convertToFastObject:convertToFastObject,setFunctionNamesIfNecessary:setFunctionNamesIfNecessary,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}function getGlobalFromName(a){for(var u=0;u<w.length;u++){if(w[u]==C)continue
if(w[u][a])return w[u][a]}}var C={},H={bH:function bH(){},
ab:function(a){var u,t=H.n(v.mangledGlobalNames[a])
if(typeof t==="string")return t
u="minified:"+a
return u},
dk:function(a){return v.types[H.D(a)]},
e:function(a){var u
if(typeof a==="string")return a
if(typeof a==="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
u=J.as(a)
if(typeof u!=="string")throw H.h(H.cm(a))
return u},
a1:function(a){return H.cW(a)+H.bQ(H.a8(a),0,null)},
cW:function(a){var u,t,s,r,q,p,o,n,m=null,l=J.w(a),k=l.constructor
if(typeof k=="function"){u=k.name
t=typeof u==="string"?u:m}else t=m
s=t==null
if(s||l===C.r||!!l.$ial){r=C.d(a)
if(s)t=r
if(r==="Object"){q=a.constructor
if(typeof q=="function"){p=String(q).match(/^\s*function\s*([\w$]*)\s*\(/)
o=p==null?m:p[1]
if(typeof o==="string"&&/^\w+$/.test(o))t=o}}return t}t=t
n=t.length
if(n>1&&C.j.O(t,0)===36){if(1>n)H.bB(P.bJ(1,m))
if(n>n)H.bB(P.bJ(n,m))
t=t.substring(1,n)}return H.ab(t)},
M:function(a){throw H.h(H.cm(a))},
bZ:function(a,b){if(a==null)J.bD(a)
throw H.h(H.co(a,b))},
co:function(a,b){var u,t,s="index"
if(typeof b!=="number"||Math.floor(b)!==b)return new P.G(!0,b,s,null)
u=H.D(J.bD(a))
if(!(b<0)){if(typeof u!=="number")return H.M(u)
t=b>=u}else t=!0
if(t)return P.cS(b,a,s,null,u)
return P.bJ(b,s)},
cm:function(a){return new P.G(!0,a,null,null)},
h:function(a){var u
if(a==null)a=new P.ai()
u=new Error()
u.dartException=a
if("defineProperty" in Object){Object.defineProperty(u,"message",{get:H.cz})
u.name=""}else u.toString=H.cz
return u},
cz:function(){return J.as(this.dartException)},
bB:function(a){throw H.h(a)},
dy:function(a){throw H.h(P.cQ(a))},
z:function(a){var u,t,s,r,q,p
a=H.dw(a.replace(String({}),'$receiver$'))
u=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(u==null)u=H.c1([],[P.q])
t=u.indexOf("\\$arguments\\$")
s=u.indexOf("\\$argumentsExpr\\$")
r=u.indexOf("\\$expr\\$")
q=u.indexOf("\\$method\\$")
p=u.indexOf("\\$receiver\\$")
return new H.aT(a.replace(new RegExp('\\\\\\$arguments\\\\\\$','g'),'((?:x|[^x])*)').replace(new RegExp('\\\\\\$argumentsExpr\\\\\\$','g'),'((?:x|[^x])*)').replace(new RegExp('\\\\\\$expr\\\\\\$','g'),'((?:x|[^x])*)').replace(new RegExp('\\\\\\$method\\\\\\$','g'),'((?:x|[^x])*)').replace(new RegExp('\\\\\\$receiver\\\\\\$','g'),'((?:x|[^x])*)'),t,s,r,q,p)},
aU:function(a){return function($expr$){var $argumentsExpr$='$arguments$'
try{$expr$.$method$($argumentsExpr$)}catch(u){return u.message}}(a)},
cc:function(a){return function($expr$){try{$expr$.$method$}catch(u){return u.message}}(a)},
ca:function(a,b){return new H.aI(a,b==null?null:b.method)},
bI:function(a,b){var u=b==null,t=u?null:b.method
return new H.aH(a,t,u?null:b.receiver)},
ac:function(a){var u,t,s,r,q,p,o,n,m,l,k,j,i,h,g=null,f=new H.bC(a)
if(a==null)return
if(typeof a!=="object")return a
if("dartException" in a)return f.$1(a.dartException)
else if(!("message" in a))return a
u=a.message
if("number" in a&&typeof a.number=="number"){t=a.number
s=t&65535
if((C.b.R(t,16)&8191)===10)switch(s){case 438:return f.$1(H.bI(H.e(u)+" (Error "+s+")",g))
case 445:case 5007:return f.$1(H.ca(H.e(u)+" (Error "+s+")",g))}}if(a instanceof TypeError){r=$.cB()
q=$.cC()
p=$.cD()
o=$.cE()
n=$.cH()
m=$.cI()
l=$.cG()
$.cF()
k=$.cK()
j=$.cJ()
i=r.i(u)
if(i!=null)return f.$1(H.bI(H.n(u),i))
else{i=q.i(u)
if(i!=null){i.method="call"
return f.$1(H.bI(H.n(u),i))}else{i=p.i(u)
if(i==null){i=o.i(u)
if(i==null){i=n.i(u)
if(i==null){i=m.i(u)
if(i==null){i=l.i(u)
if(i==null){i=o.i(u)
if(i==null){i=k.i(u)
if(i==null){i=j.i(u)
h=i!=null}else h=!0}else h=!0}else h=!0}else h=!0}else h=!0}else h=!0}else h=!0
if(h)return f.$1(H.ca(H.n(u),i))}}return f.$1(new H.aX(typeof u==="string"?u:""))}if(a instanceof RangeError){if(typeof u==="string"&&u.indexOf("call stack")!==-1)return new P.aj()
u=function(b){try{return String(b)}catch(e){}return null}(a)
return f.$1(new P.G(!1,g,g,typeof u==="string"?u.replace(/^RangeError:\s*/,""):u))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof u==="string"&&u==="too much recursion")return new P.aj()
return a},
a9:function(a){var u
if(a==null)return new H.an(a)
u=a.$cachedTrace
if(u!=null)return u
return a.$cachedTrace=new H.an(a)},
dq:function(a,b,c,d,e,f){H.f(a,"$ibF")
switch(H.D(b)){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw H.h(new P.b7("Unsupported number of arguments for wrapped closure"))},
ap:function(a,b){var u
H.D(b)
if(a==null)return
u=a.$identity
if(!!u)return u
u=function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,H.dq)
a.$identity=u
return u},
cP:function(a,b,c,d,e,f,g){var u,t,s,r,q,p,o,n,m,l=null,k=b[0],j=k.$callName,i=e?Object.create(new H.aN().constructor.prototype):Object.create(new H.ad(l,l,l,l).constructor.prototype)
i.$initialize=i.constructor
if(e)u=function static_tear_off(){this.$initialize()}
else{t=$.y
if(typeof t!=="number")return t.k()
$.y=t+1
t=new Function("a,b,c,d"+t,"this.$initialize(a,b,c,d"+t+")")
u=t}i.constructor=u
u.prototype=i
if(!e){s=H.c8(a,k,f)
s.$reflectionInfo=d}else{i.$static_name=g
s=k}if(typeof d=="number")r=function(h,a0){return function(){return h(a0)}}(H.dk,d)
else if(typeof d=="function")if(e)r=d
else{q=f?H.c6:H.bE
r=function(h,a0){return function(){return h.apply({$receiver:a0(this)},arguments)}}(d,q)}else throw H.h("Error in reflectionInfo.")
i.$S=r
i[j]=s
for(p=s,o=1;o<b.length;++o){n=b[o]
m=n.$callName
if(m!=null){n=e?n:H.c8(a,n,f)
i[m]=n}if(o===c){n.$reflectionInfo=d
p=n}}i.$C=p
i.$R=k.$R
i.$D=k.$D
return u},
cM:function(a,b,c,d){var u=H.bE
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,u)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,u)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,u)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,u)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,u)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,u)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,u)}},
c8:function(a,b,c){var u,t,s,r,q,p,o
if(c)return H.cO(a,b)
u=b.$stubName
t=b.length
s=a[u]
r=b==null?s==null:b===s
q=!r||t>=27
if(q)return H.cM(t,!r,u,b)
if(t===0){r=$.y
if(typeof r!=="number")return r.k()
$.y=r+1
p="self"+r
r="return function(){var "+p+" = this."
q=$.V
return new Function(r+H.e(q==null?$.V=H.ax("self"):q)+";return "+p+"."+H.e(u)+"();}")()}o="abcdefghijklmnopqrstuvwxyz".split("").splice(0,t).join(",")
r=$.y
if(typeof r!=="number")return r.k()
$.y=r+1
o+=r
r="return function("+o+"){return this."
q=$.V
return new Function(r+H.e(q==null?$.V=H.ax("self"):q)+"."+H.e(u)+"("+o+");}")()},
cN:function(a,b,c,d){var u=H.bE,t=H.c6
switch(b?-1:a){case 0:throw H.h(new H.aL("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,u,t)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,u,t)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,u,t)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,u,t)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,u,t)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,u,t)
default:return function(e,f,g,h){return function(){h=[g(this)]
Array.prototype.push.apply(h,arguments)
return e.apply(f(this),h)}}(d,u,t)}},
cO:function(a,b){var u,t,s,r,q,p,o,n=$.V
if(n==null)n=$.V=H.ax("self")
u=$.c5
if(u==null)u=$.c5=H.ax("receiver")
t=b.$stubName
s=b.length
r=a[t]
q=b==null?r==null:b===r
p=!q||s>=28
if(p)return H.cN(s,!q,t,b)
if(s===1){n="return function(){return this."+H.e(n)+"."+H.e(t)+"(this."+H.e(u)+");"
u=$.y
if(typeof u!=="number")return u.k()
$.y=u+1
return new Function(n+u+"}")()}o="abcdefghijklmnopqrstuvwxyz".split("").splice(0,s-1).join(",")
n="return function("+o+"){return this."+H.e(n)+"."+H.e(t)+"(this."+H.e(u)+", "+o+");"
u=$.y
if(typeof u!=="number")return u.k()
$.y=u+1
return new Function(n+u+"}")()},
bT:function(a,b,c,d,e,f,g){return H.cP(a,b,H.D(c),d,!!e,!!f,g)},
bE:function(a){return a.a},
c6:function(a){return a.c},
ax:function(a){var u,t,s,r=new H.ad("self","target","receiver","name"),q=J.c9(Object.getOwnPropertyNames(r))
for(u=q.length,t=0;t<u;++t){s=q[t]
if(r[s]===a)return s}},
dg:function(a){if(a==null)H.dc("boolean expression must not be null")
return a},
n:function(a){if(a==null)return a
if(typeof a==="string")return a
throw H.h(H.A(a,"String"))},
dU:function(a){if(a==null)return a
if(typeof a==="number")return a
throw H.h(H.A(a,"num"))},
dQ:function(a){if(a==null)return a
if(typeof a==="boolean")return a
throw H.h(H.A(a,"bool"))},
D:function(a){if(a==null)return a
if(typeof a==="number"&&Math.floor(a)===a)return a
throw H.h(H.A(a,"int"))},
dv:function(a,b){throw H.h(H.A(a,H.ab(H.n(b).substring(2))))},
f:function(a,b){if(a==null)return a
if((typeof a==="object"||typeof a==="function")&&J.w(a)[b])return a
H.dv(a,b)},
c_:function(a){if(a==null)return a
if(!!J.w(a).$ir)return a
throw H.h(H.A(a,"List<dynamic>"))},
cr:function(a){var u
if("$S" in a){u=a.$S
if(typeof u=="number")return v.types[H.D(u)]
else return a.$S()}return},
aq:function(a,b){var u
if(typeof a=="function")return!0
u=H.cr(J.w(a))
if(u==null)return!1
return H.cg(u,null,b,null)},
d:function(a,b){var u,t
if(a==null)return a
if($.bO)return a
$.bO=!0
try{if(H.aq(a,b))return a
u=H.bA(b)
t=H.A(a,u)
throw H.h(t)}finally{$.bO=!1}},
bU:function(a,b){if(a!=null&&!H.bS(a,b))H.bB(H.A(a,H.bA(b)))
return a},
A:function(a,b){return new H.aV("TypeError: "+P.aB(a)+": type '"+H.da(a)+"' is not a subtype of type '"+b+"'")},
da:function(a){var u,t=J.w(a)
if(!!t.$iW){u=H.cr(t)
if(u!=null)return H.bA(u)
return"Closure"}return H.a1(a)},
dc:function(a){throw H.h(new H.b_(a))},
dz:function(a){throw H.h(new P.az(H.n(a)))},
cs:function(a){return v.getIsolateTag(a)},
c1:function(a,b){a.$ti=b
return a},
a8:function(a){if(a==null)return
return a.$ti},
dT:function(a,b,c){return H.ar(a["$a"+H.e(c)],H.a8(b))},
x:function(a,b){var u
H.D(b)
u=H.a8(a)
return u==null?null:u[b]},
bA:function(a){return H.L(a,null)},
L:function(a,b){var u,t
H.ao(b,"$ir",[P.q],"$ar")
if(a==null)return"dynamic"
if(a===-1)return"void"
if(typeof a==="object"&&a!==null&&a.constructor===Array)return H.ab(a[0].name)+H.bQ(a,1,b)
if(typeof a=="function")return H.ab(a.name)
if(a===-2)return"dynamic"
if(typeof a==="number"){H.D(a)
if(b==null||a<0||a>=b.length)return"unexpected-generic-index:"+a
u=b.length
t=u-a-1
if(t<0||t>=u)return H.bZ(b,t)
return H.e(b[t])}if('func' in a)return H.d3(a,b)
if('futureOr' in a)return"FutureOr<"+H.L("type" in a?a.type:null,b)+">"
return"unknown-reified-type"},
d3:function(a,a0){var u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=", ",b=[P.q]
H.ao(a0,"$ir",b,"$ar")
if("bounds" in a){u=a.bounds
if(a0==null){a0=H.c1([],b)
t=null}else t=a0.length
s=a0.length
for(r=u.length,q=r;q>0;--q)C.h.F(a0,"T"+(s+q))
for(p="<",o="",q=0;q<r;++q,o=c){p+=o
b=a0.length
n=b-q-1
if(n<0)return H.bZ(a0,n)
p=C.j.k(p,a0[n])
m=u[q]
if(m!=null&&m!==P.i)p+=" extends "+H.L(m,a0)}p+=">"}else{p=""
t=null}l=!!a.v?"void":H.L(a.ret,a0)
if("args" in a){k=a.args
for(b=k.length,j="",i="",h=0;h<b;++h,i=c){g=k[h]
j=j+i+H.L(g,a0)}}else{j=""
i=""}if("opt" in a){f=a.opt
j+=i+"["
for(b=f.length,i="",h=0;h<b;++h,i=c){g=f[h]
j=j+i+H.L(g,a0)}j+="]"}if("named" in a){e=a.named
j+=i+"{"
for(b=H.dh(e),n=b.length,i="",h=0;h<n;++h,i=c){d=H.n(b[h])
j=j+i+H.L(e[d],a0)+(" "+H.e(d))}j+="}"}if(t!=null)a0.length=t
return p+"("+j+") => "+l},
bQ:function(a,b,c){var u,t,s,r,q,p
H.ao(c,"$ir",[P.q],"$ar")
if(a==null)return""
u=new P.ak("")
for(t=b,s="",r=!0,q="";t<a.length;++t,s=", "){u.a=q+s
p=a[t]
if(p!=null)r=!1
q=u.a+=H.L(p,c)}return"<"+u.h(0)+">"},
ar:function(a,b){if(a==null)return b
a=a.apply(null,b)
if(a==null)return
if(typeof a==="object"&&a!==null&&a.constructor===Array)return a
if(typeof a=="function")return a.apply(null,b)
return b},
bR:function(a,b,c,d){var u,t
H.n(b)
H.c_(c)
H.n(d)
if(a==null)return!1
u=H.a8(a)
t=J.w(a)
if(t[b]==null)return!1
return H.cl(H.ar(t[d],u),null,c,null)},
ao:function(a,b,c,d){H.n(b)
H.c_(c)
H.n(d)
if(a==null)return a
if(H.bR(a,b,c,d))return a
throw H.h(H.A(a,function(e,f){return e.replace(/[^<,> ]+/g,function(g){return f[g]||g})}(H.ab(b.substring(2))+H.bQ(c,0,null),v.mangledGlobalNames)))},
cl:function(a,b,c,d){var u,t
if(c==null)return!0
if(a==null){u=c.length
for(t=0;t<u;++t)if(!H.v(null,null,c[t],d))return!1
return!0}u=a.length
for(t=0;t<u;++t)if(!H.v(a[t],b,c[t],d))return!1
return!0},
dR:function(a,b,c){return a.apply(b,H.ar(J.w(b)["$a"+H.e(c)],H.a8(b)))},
cu:function(a){var u
if(typeof a==="number")return!1
if('futureOr' in a){u="type" in a?a.type:null
return a==null||a.name==="i"||a.name==="k"||a===-1||a===-2||H.cu(u)}return!1},
bS:function(a,b){var u,t
if(a==null)return b==null||b.name==="i"||b.name==="k"||b===-1||b===-2||H.cu(b)
if(b==null||b===-1||b.name==="i"||b===-2)return!0
if(typeof b=="object"){if('futureOr' in b)if(H.bS(a,"type" in b?b.type:null))return!0
if('func' in b)return H.aq(a,b)}u=J.w(a).constructor
t=H.a8(a)
if(t!=null){t=t.slice()
t.splice(0,0,u)
u=t}return H.v(u,null,b,null)},
l:function(a,b){if(a!=null&&!H.bS(a,b))throw H.h(H.A(a,H.bA(b)))
return a},
v:function(a,b,c,d){var u,t,s,r,q,p,o,n,m,l=null
if(a===c)return!0
if(c==null||c===-1||c.name==="i"||c===-2)return!0
if(a===-2)return!0
if(a==null||a===-1||a.name==="i"||a===-2){if(typeof c==="number")return!1
if('futureOr' in c)return H.v(a,b,"type" in c?c.type:l,d)
return!1}if(typeof a==="number")return!1
if(typeof c==="number")return!1
if(a.name==="k")return!0
if('func' in c)return H.cg(a,b,c,d)
if('func' in a)return c.name==="bF"
u=typeof a==="object"&&a!==null&&a.constructor===Array
t=u?a[0]:a
if('futureOr' in c){s="type" in c?c.type:l
if('futureOr' in a)return H.v("type" in a?a.type:l,b,s,d)
else if(H.v(a,b,s,d))return!0
else{if(!('$i'+"Y" in t.prototype))return!1
r=t.prototype["$a"+"Y"]
q=H.ar(r,u?a.slice(1):l)
return H.v(typeof q==="object"&&q!==null&&q.constructor===Array?q[0]:l,b,s,d)}}p=typeof c==="object"&&c!==null&&c.constructor===Array
o=p?c[0]:c
if(o!==t){n=o.name
if(!('$i'+n in t.prototype))return!1
m=t.prototype["$a"+n]}else m=l
if(!p)return!0
u=u?a.slice(1):l
p=c.slice(1)
return H.cl(H.ar(m,u),b,p,d)},
cg:function(a,b,c,d){var u,t,s,r,q,p,o,n,m,l,k,j,i,h,g
if(!('func' in a))return!1
if("bounds" in a){if(!("bounds" in c))return!1
u=a.bounds
t=c.bounds
if(u.length!==t.length)return!1}else if("bounds" in c)return!1
if(!H.v(a.ret,b,c.ret,d))return!1
s=a.args
r=c.args
q=a.opt
p=c.opt
o=s!=null?s.length:0
n=r!=null?r.length:0
m=q!=null?q.length:0
l=p!=null?p.length:0
if(o>n)return!1
if(o+m<n+l)return!1
for(k=0;k<o;++k)if(!H.v(r[k],d,s[k],b))return!1
for(j=k,i=0;j<n;++i,++j)if(!H.v(r[j],d,q[i],b))return!1
for(j=0;j<l;++i,++j)if(!H.v(p[j],d,q[i],b))return!1
h=a.named
g=c.named
if(g==null)return!0
if(h==null)return!1
return H.du(h,b,g,d)},
du:function(a,b,c,d){var u,t,s,r=Object.getOwnPropertyNames(c)
for(u=r.length,t=0;t<u;++t){s=r[t]
if(!Object.hasOwnProperty.call(a,s))return!1
if(!H.v(c[s],d,a[s],b))return!1}return!0},
dS:function(a,b,c){Object.defineProperty(a,H.n(b),{value:c,enumerable:false,writable:true,configurable:true})},
dr:function(a){var u,t,s,r,q=H.n($.ct.$1(a)),p=$.bs[q]
if(p!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:p,enumerable:false,writable:true,configurable:true})
return p.i}u=$.bx[q]
if(u!=null)return u
t=v.interceptorsByTag[q]
if(t==null){q=H.n($.ck.$2(a,q))
if(q!=null){p=$.bs[q]
if(p!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:p,enumerable:false,writable:true,configurable:true})
return p.i}u=$.bx[q]
if(u!=null)return u
t=v.interceptorsByTag[q]}}if(t==null)return
u=t.prototype
s=q[0]
if(s==="!"){p=H.bz(u)
$.bs[q]=p
Object.defineProperty(a,v.dispatchPropertyName,{value:p,enumerable:false,writable:true,configurable:true})
return p.i}if(s==="~"){$.bx[q]=u
return u}if(s==="-"){r=H.bz(u)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:r,enumerable:false,writable:true,configurable:true})
return r.i}if(s==="+")return H.cw(a,u)
if(s==="*")throw H.h(P.cd(q))
if(v.leafTags[q]===true){r=H.bz(u)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:r,enumerable:false,writable:true,configurable:true})
return r.i}else return H.cw(a,u)},
cw:function(a,b){var u=Object.getPrototypeOf(a)
Object.defineProperty(u,v.dispatchPropertyName,{value:J.c0(b,u,null,null),enumerable:false,writable:true,configurable:true})
return b},
bz:function(a){return J.c0(a,!1,null,!!a.$idD)},
ds:function(a,b,c){var u=b.prototype
if(v.leafTags[a]===true)return H.bz(u)
else return J.c0(u,c,null,null)},
dn:function(){if(!0===$.bY)return
$.bY=!0
H.dp()},
dp:function(){var u,t,s,r,q,p,o,n
$.bs=Object.create(null)
$.bx=Object.create(null)
H.dm()
u=v.interceptorsByTag
t=Object.getOwnPropertyNames(u)
if(typeof window!="undefined"){window
s=function(){}
for(r=0;r<t.length;++r){q=t[r]
p=$.cx.$1(q)
if(p!=null){o=H.ds(q,u[q],p)
if(o!=null){Object.defineProperty(p,v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
s.prototype=p}}}}for(r=0;r<t.length;++r){q=t[r]
if(/^[A-Za-z_]/.test(q)){n=u[q]
u["!"+q]=n
u["~"+q]=n
u["-"+q]=n
u["+"+q]=n
u["*"+q]=n}}},
dm:function(){var u,t,s,r,q,p,o=C.l()
o=H.S(C.m,H.S(C.n,H.S(C.e,H.S(C.e,H.S(C.o,H.S(C.p,H.S(C.q(C.d),o)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){u=dartNativeDispatchHooksTransformer
if(typeof u=="function")u=[u]
if(u.constructor==Array)for(t=0;t<u.length;++t){s=u[t]
if(typeof s=="function")o=s(o)||o}}r=o.getTag
q=o.getUnknownTag
p=o.prototypeForTag
$.ct=new H.bu(r)
$.ck=new H.bv(q)
$.cx=new H.bw(p)},
S:function(a,b){return a(b)||b},
dw:function(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
aT:function aT(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
aI:function aI(a,b){this.a=a
this.b=b},
aH:function aH(a,b,c){this.a=a
this.b=b
this.c=c},
aX:function aX(a){this.a=a},
bC:function bC(a){this.a=a},
an:function an(a){this.a=a
this.b=null},
W:function W(){},
aS:function aS(){},
aN:function aN(){},
ad:function ad(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
aV:function aV(a){this.a=a},
aL:function aL(a){this.a=a},
b_:function b_(a){this.a=a},
bu:function bu(a){this.a=a},
bv:function bv(a){this.a=a},
bw:function bw(a){this.a=a},
dh:function(a){return J.cV(a?Object.keys(a):[],null)}},J={
c0:function(a,b,c,d){return{i:a,p:b,e:c,x:d}},
bV:function(a){var u,t,s,r,q=a[v.dispatchPropertyName]
if(q==null)if($.bY==null){H.dn()
q=a[v.dispatchPropertyName]}if(q!=null){u=q.p
if(!1===u)return q.i
if(!0===u)return a
t=Object.getPrototypeOf(a)
if(u===t)return q.i
if(q.e===t)throw H.h(P.cd("Return interceptor for "+H.e(u(a,q))))}s=a.constructor
r=s==null?null:s[$.c2()]
if(r!=null)return r
r=H.dr(a)
if(r!=null)return r
if(typeof a=="function")return C.t
u=Object.getPrototypeOf(a)
if(u==null)return C.k
if(u===Object.prototype)return C.k
if(typeof s=="function"){Object.defineProperty(s,$.c2(),{value:C.c,enumerable:false,writable:true,configurable:true})
return C.c}return C.c},
cV:function(a,b){return J.c9(H.c1(a,[b]))},
c9:function(a){H.c_(a)
a.fixed$length=Array
return a},
w:function(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.af.prototype
return J.ae.prototype}if(typeof a=="string")return J.a_.prototype
if(a==null)return J.aF.prototype
if(typeof a=="boolean")return J.aE.prototype
if(a.constructor==Array)return J.P.prototype
if(typeof a!="object"){if(typeof a=="function")return J.Q.prototype
return a}if(a instanceof P.i)return a
return J.bV(a)},
di:function(a){if(typeof a=="string")return J.a_.prototype
if(a==null)return a
if(a.constructor==Array)return J.P.prototype
if(typeof a!="object"){if(typeof a=="function")return J.Q.prototype
return a}if(a instanceof P.i)return a
return J.bV(a)},
dj:function(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.Q.prototype
return a}if(a instanceof P.i)return a
return J.bV(a)},
cL:function(a,b,c,d){return J.dj(a).N(a,b,c,d)},
bD:function(a){return J.di(a).gj(a)},
as:function(a){return J.w(a).h(a)},
o:function o(){},
aE:function aE(){},
aF:function aF(){},
ag:function ag(){},
aJ:function aJ(){},
al:function al(){},
Q:function Q(){},
P:function P(a){this.$ti=a},
bG:function bG(a){this.$ti=a},
av:function av(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
aG:function aG(){},
af:function af(){},
ae:function ae(){},
a_:function a_(){}},P={
cY:function(){var u,t,s={}
if(self.scheduleImmediate!=null)return P.dd()
if(self.MutationObserver!=null&&self.document!=null){u=self.document.createElement("div")
t=self.document.createElement("span")
s.a=null
new self.MutationObserver(H.ap(new P.b1(s),1)).observe(u,{childList:true})
return new P.b0(s,u,t)}else if(self.setImmediate!=null)return P.de()
return P.df()},
cZ:function(a){self.scheduleImmediate(H.ap(new P.b2(H.d(a,{func:1,ret:-1})),0))},
d_:function(a){self.setImmediate(H.ap(new P.b3(H.d(a,{func:1,ret:-1})),0))},
d0:function(a){H.d(a,{func:1,ret:-1})
P.d2(0,a)},
d2:function(a,b){var u=new P.bm()
u.M(a,b)
return u},
d1:function(a,b){var u,t,s
b.a=1
try{a.J(new P.b9(b),new P.ba(b),null)}catch(s){u=H.ac(s)
t=H.a9(s)
P.dx(new P.bb(b,u,t))}},
cf:function(a,b){var u,t
for(;u=a.a,u===2;)a=H.f(a.c,"$iu")
if(u>=4){t=b.q()
b.a=a.a
b.c=a.c
P.a2(b,t)}else{t=H.f(b.c,"$iC")
b.a=2
b.c=a
a.E(t)}},
a2:function(a,b){var u,t,s,r,q,p,o,n,m,l,k,j,i=null,h={},g=h.a=a
for(;!0;){u={}
t=g.a===8
if(b==null){if(t){s=H.f(g.c,"$im")
g=g.b
r=s.a
q=s.b
g.toString
P.bp(i,i,g,r,q)}return}for(;p=b.a,p!=null;b=p){b.a=null
P.a2(h.a,b)}g=h.a
o=g.c
u.a=t
u.b=o
r=!t
if(r){q=b.c
q=(q&1)!==0||q===8}else q=!0
if(q){q=b.b
n=q.b
if(t){m=g.b
m.toString
m=m==n
if(!m)n.toString
else m=!0
m=!m}else m=!1
if(m){H.f(o,"$im")
g=g.b
r=o.a
q=o.b
g.toString
P.bp(i,i,g,r,q)
return}l=$.j
if(l!=n)$.j=n
else l=i
g=b.c
if(g===8)new P.bf(h,u,b,t).$0()
else if(r){if((g&1)!==0)new P.be(u,b,o).$0()}else if((g&2)!==0)new P.bd(h,u,b).$0()
if(l!=null)$.j=l
g=u.b
if(!!J.w(g).$iY){if(g.a>=4){k=H.f(q.c,"$iC")
q.c=null
b=q.l(k)
q.a=g.a
q.c=g.c
h.a=g
continue}else P.cf(g,q)
return}}j=b.b
k=H.f(j.c,"$iC")
j.c=null
b=j.l(k)
g=u.a
r=u.b
if(!g){H.l(r,H.x(j,0))
j.a=4
j.c=r}else{H.f(r,"$im")
j.a=8
j.c=r}h.a=j
g=j}},
d6:function(a,b){if(H.aq(a,{func:1,args:[P.i,P.p]}))return H.d(a,{func:1,ret:null,args:[P.i,P.p]})
if(H.aq(a,{func:1,args:[P.i]}))return H.d(a,{func:1,ret:null,args:[P.i]})
throw H.h(P.c4(a,"onError","Error handler must accept one Object or one Object and a StackTrace as arguments, and return a a valid result"))},
d5:function(){var u,t
for(;u=$.R,u!=null;){$.a5=null
t=u.b
$.R=t
if(t==null)$.a4=null
u.a.$0()}},
d9:function(){$.bP=!0
try{P.d5()}finally{$.a5=null
$.bP=!1
if($.R!=null)$.c3().$1(P.cn())}},
cj:function(a){var u=new P.am(H.d(a,{func:1,ret:-1}))
if($.R==null){$.R=$.a4=u
if(!$.bP)$.c3().$1(P.cn())}else $.a4=$.a4.b=u},
d8:function(a){var u,t,s
H.d(a,{func:1,ret:-1})
u=$.R
if(u==null){P.cj(a)
$.a5=$.a4
return}t=new P.am(a)
s=$.a5
if(s==null){t.b=u
$.R=$.a5=t}else{t.b=s.b
$.a5=s.b=t
if(t.b==null)$.a4=t}},
dx:function(a){var u,t=null,s={func:1,ret:-1}
H.d(a,s)
u=$.j
if(C.a===u){P.br(t,t,C.a,a)
return}u.toString
P.br(t,t,u,H.d(u.G(a),s))},
bp:function(a,b,c,d,e){var u={}
u.a=d
P.d8(new P.bq(u,e))},
ch:function(a,b,c,d,e){var u,t
H.d(d,{func:1,ret:e})
t=$.j
if(t===c)return d.$0()
$.j=c
u=t
try{t=d.$0()
return t}finally{$.j=u}},
ci:function(a,b,c,d,e,f,g){var u,t
H.d(d,{func:1,ret:f,args:[g]})
H.l(e,g)
t=$.j
if(t===c)return d.$1(e)
$.j=c
u=t
try{t=d.$1(e)
return t}finally{$.j=u}},
d7:function(a,b,c,d,e,f,g,h,i){var u,t
H.d(d,{func:1,ret:g,args:[h,i]})
H.l(e,h)
H.l(f,i)
t=$.j
if(t===c)return d.$2(e,f)
$.j=c
u=t
try{t=d.$2(e,f)
return t}finally{$.j=u}},
br:function(a,b,c,d){var u
H.d(d,{func:1,ret:-1})
u=C.a!==c
if(u)d=!(!u||!1)?c.G(d):c.S(d,-1)
P.cj(d)},
b1:function b1(a){this.a=a},
b0:function b0(a,b,c){this.a=a
this.b=b
this.c=c},
b2:function b2(a){this.a=a},
b3:function b3(a){this.a=a},
bm:function bm(){},
bn:function bn(a,b){this.a=a
this.b=b},
C:function C(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
u:function u(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
b8:function b8(a,b){this.a=a
this.b=b},
bc:function bc(a,b){this.a=a
this.b=b},
b9:function b9(a){this.a=a},
ba:function ba(a){this.a=a},
bb:function bb(a,b,c){this.a=a
this.b=b
this.c=c},
bf:function bf(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
bg:function bg(a){this.a=a},
be:function be(a,b,c){this.a=a
this.b=b
this.c=c},
bd:function bd(a,b,c){this.a=a
this.b=b
this.c=c},
am:function am(a){this.a=a
this.b=null},
aO:function aO(){},
aQ:function aQ(a,b){this.a=a
this.b=b},
aR:function aR(a,b){this.a=a
this.b=b},
aP:function aP(){},
m:function m(a,b){this.a=a
this.b=b},
bo:function bo(){},
bq:function bq(a,b){this.a=a
this.b=b},
bi:function bi(){},
bk:function bk(a,b,c){this.a=a
this.b=b
this.c=c},
bj:function bj(a,b){this.a=a
this.b=b},
bl:function bl(a,b,c){this.a=a
this.b=b
this.c=c},
cR:function(a){if(a instanceof H.W)return a.h(0)
return"Instance of '"+H.a1(a)+"'"},
cX:function(a,b,c){var u=new J.av(b,b.length,[H.x(b,0)])
if(!u.t())return a
if(c.length===0){do a+=H.e(u.d)
while(u.t())}else{a+=H.e(u.d)
for(;u.t();)a=a+c+H.e(u.d)}return a},
aB:function(a){if(typeof a==="number"||typeof a==="boolean"||null==a)return J.as(a)
if(typeof a==="string")return JSON.stringify(a)
return P.cR(a)},
c4:function(a,b,c){return new P.G(!0,a,b,c)},
bJ:function(a,b){return new P.aK(null,null,!0,a,b,"Value not in range")},
cS:function(a,b,c,d,e){var u=H.D(e==null?J.bD(b):e)
return new P.aD(u,!0,a,c,"Index out of range")},
bK:function(a){return new P.aY(a)},
cd:function(a){return new P.aW(a)},
cQ:function(a){return new P.ay(a)},
T:function T(){},
bt:function bt(){},
O:function O(){},
aw:function aw(){},
ai:function ai(){},
G:function G(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
aK:function aK(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
aD:function aD(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
aY:function aY(a){this.a=a},
aW:function aW(a){this.a=a},
ay:function ay(a){this.a=a},
aj:function aj(){},
az:function az(a){this.a=a},
b7:function b7(a){this.a=a},
aa:function aa(){},
r:function r(){},
k:function k(){},
U:function U(){},
i:function i(){},
p:function p(){},
q:function q(){},
ak:function ak(a){this.a=a},
cb:function(a,b,c,d,e){if(typeof c!=="number")return c.w()
H.l(c,e)
if(typeof d!=="number")return d.w()
return new P.J(a,b,c,H.l(d,e),[e])},
bh:function bh(){},
J:function J(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.$ti=e},
cU:function(a,b,c){var u,t
if(P.d4(a))return b+"..."+c
u=new P.ak(b)
C.h.F($.a6,a)
try{t=u
t.a=P.cX(t.a,a,", ")}finally{if(0>=$.a6.length)return H.bZ($.a6,-1)
$.a6.pop()}u.a+=c
t=u.a
return t.charCodeAt(0)==0?t:t},
d4:function(a){var u,t
for(u=$.a6.length,t=0;t<u;++t)if(a===$.a6[t])return!0
return!1}},W={
ce:function(a,b){return document.createElement(a)},
bM:function(a,b,c,d,e){var u=W.db(new W.b6(c),W.a),t=u!=null
if(t&&!0){H.d(u,{func:1,args:[W.a]})
if(t)J.cL(a,b,u,!1)}return new W.b5(a,b,u,!1,[e])},
db:function(a,b){var u
H.d(a,{func:1,ret:-1,args:[b]})
u=$.j
if(u===C.a)return a
return u.T(a,b)},
c:function c(){},
at:function at(){},
au:function au(){},
H:function H(){},
N:function N(){},
X:function X(){},
aA:function aA(){},
b:function b(){},
a:function a(){},
I:function I(){},
aC:function aC(){},
Z:function Z(){},
E:function E(){},
a0:function a0(){},
t:function t(){},
ah:function ah(){},
aM:function aM(){},
B:function B(){},
aZ:function aZ(){},
b4:function b4(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
bL:function bL(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
b5:function b5(a,b,c,d,e){var _=this
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
b6:function b6(a){this.a=a}},X={
cv:function(){var u,t="assets/tileset/tileset.png",s=H.f(window.document,"$iZ")
$.a3=s
s=H.f(s.querySelector("#canvas"),"$iH")
$.a7=s
$.K=H.f((s&&C.f).v(s,"2d"),"$iN")
s=$.a7
s.width=1024
s.height=2016
$.F=32
$.cy=H.f($.a3.querySelector("#tile"),"$iH")
s=$.a7
$.bN=H.f((s&&C.f).v(s,"2d"),"$iN")
s=$.cy
s.height=s.width=$.F
$.bW=H.f(H.f(W.ce("img",null),"$ib"),"$iE")
s=$.a3.createElement("img")
H.f(s,"$iE")
$.bW=s
s.src=t
u=W.a
W.bM(s,"load",H.d(new X.by(),{func:1,ret:-1,args:[u]}),!1,u)
$.bX=H.f(H.f(W.ce("img",null),"$ib"),"$iE")
s=$.a3.createElement("img")
H.f(s,"$iE")
$.bX=s
s.src=t
$.cp=$.a3.querySelector("#divX")
$.cq=$.a3.querySelector("#divY")
s=W.t
W.bM(document,"mousedown",H.d(X.dl(),{func:1,ret:-1,args:[s]}),!1,s)},
dt:function(a){var u,t,s,r,q,p,o
H.f(a,"$it")
u=a.clientX
t=a.clientY
s=P.U
r=$.F
if(typeof u!=="number")return u.m()
if(typeof r!=="number")return H.M(r)
q=C.i.H(u/r)-1
if(typeof t!=="number")return t.m()
p=C.i.H(t/r)-1
$.bN.clearRect(0,0,r,r)
r=$.bN
t=$.bX
u=$.F
o=P.cb(0,0,u,u,s)
if(typeof u!=="number")return H.M(u)
u=P.cb(q*u,p*u,u,u,s)
r.toString
s=[s]
H.ao(o,"$iJ",s,"$aJ")
H.ao(u,"$iJ",s,"$aJ")
r.drawImage(t,u.a,u.b,u.c,u.d,o.a,o.b,o.c,o.d)
$.cp.textContent="X:"+C.b.h(q)
$.cq.textContent="Y:"+C.b.h(p)},
dA:function(){var u,t,s,r,q=$.a7,p=q.width,o=$.F
if(typeof p!=="number")return p.m()
if(typeof o!=="number")return H.M(o)
u=p/o
q=q.height
if(typeof q!=="number")return q.m()
t=q/o
$.K.drawImage($.bW,0,0)
for(s=1;s<u;++s){q=$.K
p=$.F
if(typeof p!=="number")return H.M(p)
q.moveTo(s*p,0)
p=$.K
q=$.F
if(typeof q!=="number")return H.M(q)
p.lineTo(s*q,$.a7.height)
$.K.stroke()}for(r=1;r<t;++r){q=$.K
p=$.F
if(typeof p!=="number")return H.M(p)
q.moveTo(0,r*p)
p=$.K
q=$.a7.width
o=$.F
if(typeof o!=="number")return H.M(o)
p.lineTo(q,r*o)
$.K.stroke()}},
by:function by(){}}
var w=[C,H,J,P,W,X]
hunkHelpers.setFunctionNamesIfNecessary(w)
var $={}
H.bH.prototype={}
J.o.prototype={
h:function(a){return"Instance of '"+H.a1(a)+"'"}}
J.aE.prototype={
h:function(a){return String(a)},
$iT:1}
J.aF.prototype={
h:function(a){return"null"}}
J.ag.prototype={
h:function(a){return String(a)}}
J.aJ.prototype={}
J.al.prototype={}
J.Q.prototype={
h:function(a){var u=a[$.cA()]
if(u==null)return this.L(a)
return"JavaScript function for "+H.e(J.as(u))},
$S:function(){return{func:1,opt:[,,,,,,,,,,,,,,,,]}},
$ibF:1}
J.P.prototype={
F:function(a,b){H.l(b,H.x(a,0))
if(!!a.fixed$length)H.bB(P.bK("add"))
a.push(b)},
h:function(a){return P.cU(a,"[","]")},
gj:function(a){return a.length},
$icT:1,
$ir:1}
J.bG.prototype={}
J.av.prototype={
t:function(){var u,t=this,s=t.a,r=s.length
if(t.b!==r)throw H.h(H.dy(s))
u=t.c
if(u>=r){t.sD(null)
return!1}t.sD(s[u]);++t.c
return!0},
sD:function(a){this.d=H.l(a,H.x(this,0))}}
J.aG.prototype={
H:function(a){if(a>0){if(a!==1/0)return Math.round(a)}else if(a>-1/0)return 0-Math.round(0-a)
throw H.h(P.bK(""+a+".round()"))},
h:function(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
R:function(a,b){var u
if(a>0)u=this.P(a,b)
else{u=b>31?31:b
u=a>>u>>>0}return u},
P:function(a,b){return b>31?0:a>>>b},
$iU:1}
J.af.prototype={$iaa:1}
J.ae.prototype={}
J.a_.prototype={
O:function(a,b){if(b>=a.length)throw H.h(H.co(a,b))
return a.charCodeAt(b)},
k:function(a,b){if(typeof b!=="string")throw H.h(P.c4(b,null,null))
return a+b},
h:function(a){return a},
gj:function(a){return a.length},
$iq:1}
H.aT.prototype={
i:function(a){var u,t,s=this,r=new RegExp(s.a).exec(a)
if(r==null)return
u=Object.create(null)
t=s.b
if(t!==-1)u.arguments=r[t+1]
t=s.c
if(t!==-1)u.argumentsExpr=r[t+1]
t=s.d
if(t!==-1)u.expr=r[t+1]
t=s.e
if(t!==-1)u.method=r[t+1]
t=s.f
if(t!==-1)u.receiver=r[t+1]
return u}}
H.aI.prototype={
h:function(a){var u=this.b
if(u==null)return"NoSuchMethodError: "+H.e(this.a)
return"NoSuchMethodError: method not found: '"+u+"' on null"}}
H.aH.prototype={
h:function(a){var u,t=this,s="NoSuchMethodError: method not found: '",r=t.b
if(r==null)return"NoSuchMethodError: "+H.e(t.a)
u=t.c
if(u==null)return s+r+"' ("+H.e(t.a)+")"
return s+r+"' on '"+u+"' ("+H.e(t.a)+")"}}
H.aX.prototype={
h:function(a){var u=this.a
return u.length===0?"Error":"Error: "+u}}
H.bC.prototype={
$1:function(a){if(!!J.w(a).$iO)if(a.$thrownJsError==null)a.$thrownJsError=this.a
return a},
$S:3}
H.an.prototype={
h:function(a){var u,t=this.b
if(t!=null)return t
t=this.a
u=t!==null&&typeof t==="object"?t.stack:null
return this.b=u==null?"":u},
$ip:1}
H.W.prototype={
h:function(a){return"Closure '"+H.a1(this).trim()+"'"},
$ibF:1,
ga_:function(){return this},
$C:"$1",
$R:1,
$D:null}
H.aS.prototype={}
H.aN.prototype={
h:function(a){var u=this.$static_name
if(u==null)return"Closure of unknown static method"
return"Closure '"+H.ab(u)+"'"}}
H.ad.prototype={
h:function(a){var u=this.c
if(u==null)u=this.a
return"Closure '"+H.e(this.d)+"' of "+("Instance of '"+H.a1(u)+"'")}}
H.aV.prototype={
h:function(a){return this.a}}
H.aL.prototype={
h:function(a){return"RuntimeError: "+this.a}}
H.b_.prototype={
h:function(a){return"Assertion failed: "+P.aB(this.a)}}
H.bu.prototype={
$1:function(a){return this.a(a)},
$S:3}
H.bv.prototype={
$2:function(a,b){return this.a(a,b)},
$S:5}
H.bw.prototype={
$1:function(a){return this.a(H.n(a))},
$S:6}
P.b1.prototype={
$1:function(a){var u=this.a,t=u.a
u.a=null
t.$0()},
$S:4}
P.b0.prototype={
$1:function(a){var u,t
this.a.a=H.d(a,{func:1,ret:-1})
u=this.b
t=this.c
u.firstChild?u.removeChild(t):u.appendChild(t)},
$S:7}
P.b2.prototype={
$0:function(){this.a.$0()},
$S:0}
P.b3.prototype={
$0:function(){this.a.$0()},
$S:0}
P.bm.prototype={
M:function(a,b){if(self.setTimeout!=null)self.setTimeout(H.ap(new P.bn(this,b),0),a)
else throw H.h(P.bK("`setTimeout()` not found."))}}
P.bn.prototype={
$0:function(){this.b.$0()},
$S:1}
P.C.prototype={
V:function(a){if(this.c!==6)return!0
return this.b.b.u(H.d(this.d,{func:1,ret:P.T,args:[P.i]}),a.a,P.T,P.i)},
U:function(a){var u=this.e,t=P.i,s={futureOr:1,type:H.x(this,1)},r=this.b.b
if(H.aq(u,{func:1,args:[P.i,P.p]}))return H.bU(r.W(u,a.a,a.b,null,t,P.p),s)
else return H.bU(r.u(H.d(u,{func:1,args:[P.i]}),a.a,null,t),s)}}
P.u.prototype={
J:function(a,b,c){var u,t,s,r=H.x(this,0)
H.d(a,{func:1,ret:{futureOr:1,type:c},args:[r]})
u=$.j
if(u!==C.a){u.toString
H.d(a,{func:1,ret:{futureOr:1,type:c},args:[r]})
if(b!=null)b=P.d6(b,u)}H.d(a,{func:1,ret:{futureOr:1,type:c},args:[r]})
t=new P.u($.j,[c])
s=b==null?1:3
this.A(new P.C(t,s,a,b,[r,c]))
return t},
Z:function(a,b){return this.J(a,null,b)},
A:function(a){var u,t=this,s=t.a
if(s<=1){a.a=H.f(t.c,"$iC")
t.c=a}else{if(s===2){u=H.f(t.c,"$iu")
s=u.a
if(s<4){u.A(a)
return}t.a=s
t.c=u.c}s=t.b
s.toString
P.br(null,null,s,H.d(new P.b8(t,a),{func:1,ret:-1}))}},
E:function(a){var u,t,s,r,q,p=this,o={}
o.a=a
if(a==null)return
u=p.a
if(u<=1){t=H.f(p.c,"$iC")
s=p.c=a
if(t!=null){for(;r=s.a,r!=null;s=r);s.a=t}}else{if(u===2){q=H.f(p.c,"$iu")
u=q.a
if(u<4){q.E(a)
return}p.a=u
p.c=q.c}o.a=p.l(a)
u=p.b
u.toString
P.br(null,null,u,H.d(new P.bc(o,p),{func:1,ret:-1}))}},
q:function(){var u=H.f(this.c,"$iC")
this.c=null
return this.l(u)},
l:function(a){var u,t,s
for(u=a,t=null;u!=null;t=u,u=s){s=u.a
u.a=t}return t},
B:function(a){var u,t,s=this,r=H.x(s,0)
H.bU(a,{futureOr:1,type:r})
u=s.$ti
if(H.bR(a,"$iY",u,"$aY"))if(H.bR(a,"$iu",u,null))P.cf(a,s)
else P.d1(a,s)
else{t=s.q()
H.l(a,r)
s.a=4
s.c=a
P.a2(s,t)}},
C:function(a,b){var u,t=this
H.f(b,"$ip")
u=t.q()
t.a=8
t.c=new P.m(a,b)
P.a2(t,u)},
$iY:1}
P.b8.prototype={
$0:function(){P.a2(this.a,this.b)},
$S:0}
P.bc.prototype={
$0:function(){P.a2(this.b,this.a.a)},
$S:0}
P.b9.prototype={
$1:function(a){var u=this.a
u.a=0
u.B(a)},
$S:4}
P.ba.prototype={
$2:function(a,b){H.f(b,"$ip")
this.a.C(a,b)},
$1:function(a){return this.$2(a,null)},
$S:8}
P.bb.prototype={
$0:function(){this.a.C(this.b,this.c)},
$S:0}
P.bf.prototype={
$0:function(){var u,t,s,r,q,p,o=this,n=null
try{s=o.c
n=s.b.b.I(H.d(s.d,{func:1}),null)}catch(r){u=H.ac(r)
t=H.a9(r)
if(o.d){s=H.f(o.a.a.c,"$im").a
q=u
q=s==null?q==null:s===q
s=q}else s=!1
q=o.b
if(s)q.b=H.f(o.a.a.c,"$im")
else q.b=new P.m(u,t)
q.a=!0
return}if(!!J.w(n).$iY){if(n instanceof P.u&&n.a>=4){if(n.a===8){s=o.b
s.b=H.f(n.c,"$im")
s.a=!0}return}p=o.a.a
s=o.b
s.b=n.Z(new P.bg(p),null)
s.a=!1}},
$S:1}
P.bg.prototype={
$1:function(a){return this.a},
$S:9}
P.be.prototype={
$0:function(){var u,t,s,r,q,p,o,n=this
try{s=n.b
r=H.x(s,0)
q=H.l(n.c,r)
p=H.x(s,1)
n.a.b=s.b.b.u(H.d(s.d,{func:1,ret:{futureOr:1,type:p},args:[r]}),q,{futureOr:1,type:p},r)}catch(o){u=H.ac(o)
t=H.a9(o)
s=n.a
s.b=new P.m(u,t)
s.a=!0}},
$S:1}
P.bd.prototype={
$0:function(){var u,t,s,r,q,p,o,n,m=this
try{u=H.f(m.a.a.c,"$im")
r=m.c
if(H.dg(r.V(u))&&r.e!=null){q=m.b
q.b=r.U(u)
q.a=!1}}catch(p){t=H.ac(p)
s=H.a9(p)
r=H.f(m.a.a.c,"$im")
q=r.a
o=t
n=m.b
if(q==null?o==null:q===o)n.b=r
else n.b=new P.m(t,s)
n.a=!0}},
$S:1}
P.am.prototype={}
P.aO.prototype={
gj:function(a){var u,t,s=this,r={},q=new P.u($.j,[P.aa])
r.a=0
u=H.x(s,0)
t=H.d(new P.aQ(r,s),{func:1,ret:-1,args:[u]})
H.d(new P.aR(r,q),{func:1,ret:-1})
W.bM(s.a,s.b,t,!1,u)
return q}}
P.aQ.prototype={
$1:function(a){H.l(a,H.x(this.b,0));++this.a.a},
$S:function(){return{func:1,ret:P.k,args:[H.x(this.b,0)]}}}
P.aR.prototype={
$0:function(){this.b.B(this.a.a)},
$S:0}
P.aP.prototype={}
P.m.prototype={
h:function(a){return H.e(this.a)},
$iO:1}
P.bo.prototype={$idO:1}
P.bq.prototype={
$0:function(){var u,t=this.a,s=t.a
t=s==null?t.a=new P.ai():s
s=this.b
if(s==null)throw H.h(t)
u=H.h(t)
u.stack=s.h(0)
throw u},
$S:0}
P.bi.prototype={
X:function(a){var u,t,s,r=null
H.d(a,{func:1,ret:-1})
try{if(C.a===$.j){a.$0()
return}P.ch(r,r,this,a,-1)}catch(s){u=H.ac(s)
t=H.a9(s)
P.bp(r,r,this,u,H.f(t,"$ip"))}},
Y:function(a,b,c){var u,t,s,r=null
H.d(a,{func:1,ret:-1,args:[c]})
H.l(b,c)
try{if(C.a===$.j){a.$1(b)
return}P.ci(r,r,this,a,b,-1,c)}catch(s){u=H.ac(s)
t=H.a9(s)
P.bp(r,r,this,u,H.f(t,"$ip"))}},
S:function(a,b){return new P.bk(this,H.d(a,{func:1,ret:b}),b)},
G:function(a){return new P.bj(this,H.d(a,{func:1,ret:-1}))},
T:function(a,b){return new P.bl(this,H.d(a,{func:1,ret:-1,args:[b]}),b)},
I:function(a,b){H.d(a,{func:1,ret:b})
if($.j===C.a)return a.$0()
return P.ch(null,null,this,a,b)},
u:function(a,b,c,d){H.d(a,{func:1,ret:c,args:[d]})
H.l(b,d)
if($.j===C.a)return a.$1(b)
return P.ci(null,null,this,a,b,c,d)},
W:function(a,b,c,d,e,f){H.d(a,{func:1,ret:d,args:[e,f]})
H.l(b,e)
H.l(c,f)
if($.j===C.a)return a.$2(b,c)
return P.d7(null,null,this,a,b,c,d,e,f)}}
P.bk.prototype={
$0:function(){return this.a.I(this.b,this.c)},
$S:function(){return{func:1,ret:this.c}}}
P.bj.prototype={
$0:function(){return this.a.X(this.b)},
$S:1}
P.bl.prototype={
$1:function(a){var u=this.c
return this.a.Y(this.b,H.l(a,u),u)},
$S:function(){return{func:1,ret:-1,args:[this.c]}}}
P.T.prototype={}
P.bt.prototype={}
P.O.prototype={}
P.aw.prototype={
h:function(a){return"Assertion failed"}}
P.ai.prototype={
h:function(a){return"Throw of null."}}
P.G.prototype={
gp:function(){return"Invalid argument"+(!this.a?"(s)":"")},
gn:function(){return""},
h:function(a){var u,t,s,r,q=this,p=q.c,o=p!=null?" ("+p+")":""
p=q.d
u=p==null?"":": "+p
t=q.gp()+o+u
if(!q.a)return t
s=q.gn()
r=P.aB(q.b)
return t+s+": "+r}}
P.aK.prototype={
gp:function(){return"RangeError"},
gn:function(){var u,t,s=this.e
if(s==null){s=this.f
u=s!=null?": Not less than or equal to "+H.e(s):""}else{t=this.f
if(t==null)u=": Not greater than or equal to "+H.e(s)
else if(t>s)u=": Not in range "+H.e(s)+".."+H.e(t)+", inclusive"
else u=t<s?": Valid value range is empty":": Only valid value is "+H.e(s)}return u}}
P.aD.prototype={
gp:function(){return"RangeError"},
gn:function(){var u,t=H.D(this.b)
if(typeof t!=="number")return t.w()
if(t<0)return": index must not be negative"
u=this.f
if(u===0)return": no indices are valid"
return": index should be less than "+H.e(u)},
gj:function(a){return this.f}}
P.aY.prototype={
h:function(a){return"Unsupported operation: "+this.a}}
P.aW.prototype={
h:function(a){var u=this.a
return u!=null?"UnimplementedError: "+u:"UnimplementedError"}}
P.ay.prototype={
h:function(a){var u=this.a
if(u==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+P.aB(u)+"."}}
P.aj.prototype={
h:function(a){return"Stack Overflow"},
$iO:1}
P.az.prototype={
h:function(a){var u=this.a
return u==null?"Reading static variable during its initialization":"Reading static variable '"+u+"' during its initialization"}}
P.b7.prototype={
h:function(a){return"Exception: "+this.a}}
P.aa.prototype={}
P.r.prototype={$icT:1}
P.k.prototype={
h:function(a){return"null"}}
P.U.prototype={}
P.i.prototype={constructor:P.i,$ii:1,
h:function(a){return"Instance of '"+H.a1(this)+"'"},
toString:function(){return this.h(this)}}
P.p.prototype={}
P.q.prototype={}
P.ak.prototype={
gj:function(a){return this.a.length},
h:function(a){var u=this.a
return u.charCodeAt(0)==0?u:u}}
W.c.prototype={}
W.at.prototype={
h:function(a){return String(a)}}
W.au.prototype={
h:function(a){return String(a)}}
W.H.prototype={
v:function(a,b){return a.getContext(b)},
$iH:1,
$ic7:1}
W.N.prototype={$iN:1}
W.X.prototype={}
W.aA.prototype={
h:function(a){return String(a)}}
W.b.prototype={
h:function(a){return a.localName},
$ib:1}
W.a.prototype={$ia:1}
W.I.prototype={
N:function(a,b,c,d){return a.addEventListener(b,H.ap(H.d(c,{func:1,args:[W.a]}),1),!1)},
$iI:1}
W.aC.prototype={
gj:function(a){return a.length}}
W.Z.prototype={$iZ:1}
W.E.prototype={$iE:1,$ic7:1}
W.a0.prototype={}
W.t.prototype={$it:1}
W.ah.prototype={
h:function(a){var u=a.nodeValue
return u==null?this.K(a):u}}
W.aM.prototype={
gj:function(a){return a.length}}
W.B.prototype={}
W.aZ.prototype={$ic7:1}
W.b4.prototype={}
W.bL.prototype={}
W.b5.prototype={}
W.b6.prototype={
$1:function(a){return this.a.$1(H.f(a,"$ia"))},
$S:10}
P.bh.prototype={
h:function(a){var u=this
return"Rectangle ("+u.a+", "+u.b+") "+H.e(u.c)+" x "+H.e(u.d)}}
P.J.prototype={}
X.by.prototype={
$1:function(a){return X.dA()},
$S:11};(function aliases(){var u=J.o.prototype
u.K=u.h
u=J.ag.prototype
u.L=u.h})();(function installTearOffs(){var u=hunkHelpers._static_1,t=hunkHelpers._static_0
u(P,"dd","cZ",2)
u(P,"de","d_",2)
u(P,"df","d0",2)
t(P,"cn","d9",1)
u(X,"dl","dt",12)})();(function inheritance(){var u=hunkHelpers.inherit,t=hunkHelpers.inheritMany
u(P.i,null)
t(P.i,[H.bH,J.o,J.av,H.aT,P.O,H.W,H.an,P.bm,P.C,P.u,P.am,P.aO,P.aP,P.m,P.bo,P.T,P.U,P.aj,P.b7,P.r,P.k,P.p,P.q,P.ak,P.bh])
t(J.o,[J.aE,J.aF,J.ag,J.P,J.aG,J.a_,W.I,W.N,W.aA,W.a])
t(J.ag,[J.aJ,J.al,J.Q])
u(J.bG,J.P)
t(J.aG,[J.af,J.ae])
t(P.O,[H.aI,H.aH,H.aX,H.aV,H.aL,P.aw,P.ai,P.G,P.aY,P.aW,P.ay,P.az])
t(H.W,[H.bC,H.aS,H.bu,H.bv,H.bw,P.b1,P.b0,P.b2,P.b3,P.bn,P.b8,P.bc,P.b9,P.ba,P.bb,P.bf,P.bg,P.be,P.bd,P.aQ,P.aR,P.bq,P.bk,P.bj,P.bl,W.b6,X.by])
t(H.aS,[H.aN,H.ad])
u(H.b_,P.aw)
u(P.bi,P.bo)
t(P.U,[P.bt,P.aa])
t(P.G,[P.aK,P.aD])
u(W.ah,W.I)
t(W.ah,[W.b,W.X])
u(W.c,W.b)
t(W.c,[W.at,W.au,W.H,W.aC,W.E,W.a0,W.aM])
u(W.Z,W.X)
u(W.B,W.a)
u(W.t,W.B)
u(W.aZ,W.a0)
u(W.b4,P.aO)
u(W.bL,W.b4)
u(W.b5,P.aP)
u(P.J,P.bh)})();(function constants(){C.f=W.H.prototype
C.r=J.o.prototype
C.h=J.P.prototype
C.i=J.ae.prototype
C.b=J.af.prototype
C.j=J.a_.prototype
C.t=J.Q.prototype
C.k=J.aJ.prototype
C.c=J.al.prototype
C.d=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
C.l=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (self.HTMLElement && object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof navigator == "object";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
C.q=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var ua = navigator.userAgent;
    if (ua.indexOf("DumpRenderTree") >= 0) return hooks;
    if (ua.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
C.m=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
C.n=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
C.p=function(hooks) {
  var userAgent = typeof navigator == "object" ? navigator.userAgent : "";
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
C.o=function(hooks) {
  var userAgent = typeof navigator == "object" ? navigator.userAgent : "";
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
C.e=function(hooks) { return hooks; }

C.a=new P.bi()})()
var v={mangledGlobalNames:{aa:"int",bt:"double",U:"num",q:"String",T:"bool",k:"Null",r:"List"},mangledNames:{},getTypeFromName:getGlobalFromName,metadata:[],types:[{func:1,ret:P.k},{func:1,ret:-1},{func:1,ret:-1,args:[{func:1,ret:-1}]},{func:1,args:[,]},{func:1,ret:P.k,args:[,]},{func:1,args:[,P.q]},{func:1,args:[P.q]},{func:1,ret:P.k,args:[{func:1,ret:-1}]},{func:1,ret:P.k,args:[,],opt:[P.p]},{func:1,ret:[P.u,,],args:[,]},{func:1,args:[W.a]},{func:1,ret:-1,args:[W.a]},{func:1,ret:-1,args:[W.t]}],interceptorsByTag:null,leafTags:null};(function staticFields(){$.y=0
$.V=null
$.c5=null
$.bO=!1
$.ct=null
$.ck=null
$.cx=null
$.bs=null
$.bx=null
$.bY=null
$.R=null
$.a4=null
$.a5=null
$.bP=!1
$.j=C.a
$.a6=[]
$.a3=null
$.K=null
$.bN=null
$.a7=null
$.cy=null
$.bW=null
$.bX=null
$.cp=null
$.cq=null
$.F=null})();(function lazyInitializers(){var u=hunkHelpers.lazy
u($,"dB","cA",function(){return H.cs("_$dart_dartClosure")})
u($,"dC","c2",function(){return H.cs("_$dart_js")})
u($,"dE","cB",function(){return H.z(H.aU({
toString:function(){return"$receiver$"}}))})
u($,"dF","cC",function(){return H.z(H.aU({$method$:null,
toString:function(){return"$receiver$"}}))})
u($,"dG","cD",function(){return H.z(H.aU(null))})
u($,"dH","cE",function(){return H.z(function(){var $argumentsExpr$='$arguments$'
try{null.$method$($argumentsExpr$)}catch(t){return t.message}}())})
u($,"dK","cH",function(){return H.z(H.aU(void 0))})
u($,"dL","cI",function(){return H.z(function(){var $argumentsExpr$='$arguments$'
try{(void 0).$method$($argumentsExpr$)}catch(t){return t.message}}())})
u($,"dJ","cG",function(){return H.z(H.cc(null))})
u($,"dI","cF",function(){return H.z(function(){try{null.$method$}catch(t){return t.message}}())})
u($,"dN","cK",function(){return H.z(H.cc(void 0))})
u($,"dM","cJ",function(){return H.z(function(){try{(void 0).$method$}catch(t){return t.message}}())})
u($,"dP","c3",function(){return P.cY()})})();(function nativeSupport(){!function(){var u=function(a){var o={}
o[a]=1
return Object.keys(hunkHelpers.convertToFastObject(o))[0]}
v.getIsolateTag=function(a){return u("___dart_"+a+v.isolateTag)}
var t="___dart_isolate_tags_"
var s=Object[t]||(Object[t]=Object.create(null))
var r="_ZxYxX"
for(var q=0;;q++){var p=u(r+"_"+q+"_")
if(!(p in s)){s[p]=1
v.isolateTag=p
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({DOMError:J.o,MediaError:J.o,NavigatorUserMediaError:J.o,OverconstrainedError:J.o,PositionError:J.o,WebGLRenderingContext:J.o,WebGL2RenderingContext:J.o,SQLError:J.o,HTMLBRElement:W.c,HTMLBaseElement:W.c,HTMLBodyElement:W.c,HTMLButtonElement:W.c,HTMLContentElement:W.c,HTMLDListElement:W.c,HTMLDataElement:W.c,HTMLDataListElement:W.c,HTMLDetailsElement:W.c,HTMLDialogElement:W.c,HTMLDivElement:W.c,HTMLEmbedElement:W.c,HTMLFieldSetElement:W.c,HTMLHRElement:W.c,HTMLHeadElement:W.c,HTMLHeadingElement:W.c,HTMLHtmlElement:W.c,HTMLIFrameElement:W.c,HTMLInputElement:W.c,HTMLLIElement:W.c,HTMLLabelElement:W.c,HTMLLegendElement:W.c,HTMLLinkElement:W.c,HTMLMapElement:W.c,HTMLMenuElement:W.c,HTMLMetaElement:W.c,HTMLMeterElement:W.c,HTMLModElement:W.c,HTMLOListElement:W.c,HTMLObjectElement:W.c,HTMLOptGroupElement:W.c,HTMLOptionElement:W.c,HTMLOutputElement:W.c,HTMLParagraphElement:W.c,HTMLParamElement:W.c,HTMLPictureElement:W.c,HTMLPreElement:W.c,HTMLProgressElement:W.c,HTMLQuoteElement:W.c,HTMLScriptElement:W.c,HTMLShadowElement:W.c,HTMLSlotElement:W.c,HTMLSourceElement:W.c,HTMLSpanElement:W.c,HTMLStyleElement:W.c,HTMLTableCaptionElement:W.c,HTMLTableCellElement:W.c,HTMLTableDataCellElement:W.c,HTMLTableHeaderCellElement:W.c,HTMLTableColElement:W.c,HTMLTableElement:W.c,HTMLTableRowElement:W.c,HTMLTableSectionElement:W.c,HTMLTemplateElement:W.c,HTMLTextAreaElement:W.c,HTMLTimeElement:W.c,HTMLTitleElement:W.c,HTMLTrackElement:W.c,HTMLUListElement:W.c,HTMLUnknownElement:W.c,HTMLDirectoryElement:W.c,HTMLFontElement:W.c,HTMLFrameElement:W.c,HTMLFrameSetElement:W.c,HTMLMarqueeElement:W.c,HTMLElement:W.c,HTMLAnchorElement:W.at,HTMLAreaElement:W.au,HTMLCanvasElement:W.H,CanvasRenderingContext2D:W.N,XMLDocument:W.X,Document:W.X,DOMException:W.aA,SVGAElement:W.b,SVGAnimateElement:W.b,SVGAnimateMotionElement:W.b,SVGAnimateTransformElement:W.b,SVGAnimationElement:W.b,SVGCircleElement:W.b,SVGClipPathElement:W.b,SVGDefsElement:W.b,SVGDescElement:W.b,SVGDiscardElement:W.b,SVGEllipseElement:W.b,SVGFEBlendElement:W.b,SVGFEColorMatrixElement:W.b,SVGFEComponentTransferElement:W.b,SVGFECompositeElement:W.b,SVGFEConvolveMatrixElement:W.b,SVGFEDiffuseLightingElement:W.b,SVGFEDisplacementMapElement:W.b,SVGFEDistantLightElement:W.b,SVGFEFloodElement:W.b,SVGFEFuncAElement:W.b,SVGFEFuncBElement:W.b,SVGFEFuncGElement:W.b,SVGFEFuncRElement:W.b,SVGFEGaussianBlurElement:W.b,SVGFEImageElement:W.b,SVGFEMergeElement:W.b,SVGFEMergeNodeElement:W.b,SVGFEMorphologyElement:W.b,SVGFEOffsetElement:W.b,SVGFEPointLightElement:W.b,SVGFESpecularLightingElement:W.b,SVGFESpotLightElement:W.b,SVGFETileElement:W.b,SVGFETurbulenceElement:W.b,SVGFilterElement:W.b,SVGForeignObjectElement:W.b,SVGGElement:W.b,SVGGeometryElement:W.b,SVGGraphicsElement:W.b,SVGImageElement:W.b,SVGLineElement:W.b,SVGLinearGradientElement:W.b,SVGMarkerElement:W.b,SVGMaskElement:W.b,SVGMetadataElement:W.b,SVGPathElement:W.b,SVGPatternElement:W.b,SVGPolygonElement:W.b,SVGPolylineElement:W.b,SVGRadialGradientElement:W.b,SVGRectElement:W.b,SVGScriptElement:W.b,SVGSetElement:W.b,SVGStopElement:W.b,SVGStyleElement:W.b,SVGElement:W.b,SVGSVGElement:W.b,SVGSwitchElement:W.b,SVGSymbolElement:W.b,SVGTSpanElement:W.b,SVGTextContentElement:W.b,SVGTextElement:W.b,SVGTextPathElement:W.b,SVGTextPositioningElement:W.b,SVGTitleElement:W.b,SVGUseElement:W.b,SVGViewElement:W.b,SVGGradientElement:W.b,SVGComponentTransferFunctionElement:W.b,SVGFEDropShadowElement:W.b,SVGMPathElement:W.b,Element:W.b,AbortPaymentEvent:W.a,AnimationEvent:W.a,AnimationPlaybackEvent:W.a,ApplicationCacheErrorEvent:W.a,BackgroundFetchClickEvent:W.a,BackgroundFetchEvent:W.a,BackgroundFetchFailEvent:W.a,BackgroundFetchedEvent:W.a,BeforeInstallPromptEvent:W.a,BeforeUnloadEvent:W.a,BlobEvent:W.a,CanMakePaymentEvent:W.a,ClipboardEvent:W.a,CloseEvent:W.a,CustomEvent:W.a,DeviceMotionEvent:W.a,DeviceOrientationEvent:W.a,ErrorEvent:W.a,ExtendableEvent:W.a,ExtendableMessageEvent:W.a,FetchEvent:W.a,FontFaceSetLoadEvent:W.a,ForeignFetchEvent:W.a,GamepadEvent:W.a,HashChangeEvent:W.a,InstallEvent:W.a,MediaEncryptedEvent:W.a,MediaKeyMessageEvent:W.a,MediaQueryListEvent:W.a,MediaStreamEvent:W.a,MediaStreamTrackEvent:W.a,MessageEvent:W.a,MIDIConnectionEvent:W.a,MIDIMessageEvent:W.a,MutationEvent:W.a,NotificationEvent:W.a,PageTransitionEvent:W.a,PaymentRequestEvent:W.a,PaymentRequestUpdateEvent:W.a,PopStateEvent:W.a,PresentationConnectionAvailableEvent:W.a,PresentationConnectionCloseEvent:W.a,ProgressEvent:W.a,PromiseRejectionEvent:W.a,PushEvent:W.a,RTCDataChannelEvent:W.a,RTCDTMFToneChangeEvent:W.a,RTCPeerConnectionIceEvent:W.a,RTCTrackEvent:W.a,SecurityPolicyViolationEvent:W.a,SensorErrorEvent:W.a,SpeechRecognitionError:W.a,SpeechRecognitionEvent:W.a,SpeechSynthesisEvent:W.a,StorageEvent:W.a,SyncEvent:W.a,TrackEvent:W.a,TransitionEvent:W.a,WebKitTransitionEvent:W.a,VRDeviceEvent:W.a,VRDisplayEvent:W.a,VRSessionEvent:W.a,MojoInterfaceRequestEvent:W.a,ResourceProgressEvent:W.a,USBConnectionEvent:W.a,IDBVersionChangeEvent:W.a,AudioProcessingEvent:W.a,OfflineAudioCompletionEvent:W.a,WebGLContextEvent:W.a,Event:W.a,InputEvent:W.a,Window:W.I,DOMWindow:W.I,EventTarget:W.I,HTMLFormElement:W.aC,HTMLDocument:W.Z,HTMLImageElement:W.E,HTMLAudioElement:W.a0,HTMLMediaElement:W.a0,MouseEvent:W.t,DragEvent:W.t,PointerEvent:W.t,WheelEvent:W.t,Node:W.ah,HTMLSelectElement:W.aM,CompositionEvent:W.B,FocusEvent:W.B,KeyboardEvent:W.B,TextEvent:W.B,TouchEvent:W.B,UIEvent:W.B,HTMLVideoElement:W.aZ})
hunkHelpers.setOrUpdateLeafTags({DOMError:true,MediaError:true,NavigatorUserMediaError:true,OverconstrainedError:true,PositionError:true,WebGLRenderingContext:true,WebGL2RenderingContext:true,SQLError:true,HTMLBRElement:true,HTMLBaseElement:true,HTMLBodyElement:true,HTMLButtonElement:true,HTMLContentElement:true,HTMLDListElement:true,HTMLDataElement:true,HTMLDataListElement:true,HTMLDetailsElement:true,HTMLDialogElement:true,HTMLDivElement:true,HTMLEmbedElement:true,HTMLFieldSetElement:true,HTMLHRElement:true,HTMLHeadElement:true,HTMLHeadingElement:true,HTMLHtmlElement:true,HTMLIFrameElement:true,HTMLInputElement:true,HTMLLIElement:true,HTMLLabelElement:true,HTMLLegendElement:true,HTMLLinkElement:true,HTMLMapElement:true,HTMLMenuElement:true,HTMLMetaElement:true,HTMLMeterElement:true,HTMLModElement:true,HTMLOListElement:true,HTMLObjectElement:true,HTMLOptGroupElement:true,HTMLOptionElement:true,HTMLOutputElement:true,HTMLParagraphElement:true,HTMLParamElement:true,HTMLPictureElement:true,HTMLPreElement:true,HTMLProgressElement:true,HTMLQuoteElement:true,HTMLScriptElement:true,HTMLShadowElement:true,HTMLSlotElement:true,HTMLSourceElement:true,HTMLSpanElement:true,HTMLStyleElement:true,HTMLTableCaptionElement:true,HTMLTableCellElement:true,HTMLTableDataCellElement:true,HTMLTableHeaderCellElement:true,HTMLTableColElement:true,HTMLTableElement:true,HTMLTableRowElement:true,HTMLTableSectionElement:true,HTMLTemplateElement:true,HTMLTextAreaElement:true,HTMLTimeElement:true,HTMLTitleElement:true,HTMLTrackElement:true,HTMLUListElement:true,HTMLUnknownElement:true,HTMLDirectoryElement:true,HTMLFontElement:true,HTMLFrameElement:true,HTMLFrameSetElement:true,HTMLMarqueeElement:true,HTMLElement:false,HTMLAnchorElement:true,HTMLAreaElement:true,HTMLCanvasElement:true,CanvasRenderingContext2D:true,XMLDocument:true,Document:false,DOMException:true,SVGAElement:true,SVGAnimateElement:true,SVGAnimateMotionElement:true,SVGAnimateTransformElement:true,SVGAnimationElement:true,SVGCircleElement:true,SVGClipPathElement:true,SVGDefsElement:true,SVGDescElement:true,SVGDiscardElement:true,SVGEllipseElement:true,SVGFEBlendElement:true,SVGFEColorMatrixElement:true,SVGFEComponentTransferElement:true,SVGFECompositeElement:true,SVGFEConvolveMatrixElement:true,SVGFEDiffuseLightingElement:true,SVGFEDisplacementMapElement:true,SVGFEDistantLightElement:true,SVGFEFloodElement:true,SVGFEFuncAElement:true,SVGFEFuncBElement:true,SVGFEFuncGElement:true,SVGFEFuncRElement:true,SVGFEGaussianBlurElement:true,SVGFEImageElement:true,SVGFEMergeElement:true,SVGFEMergeNodeElement:true,SVGFEMorphologyElement:true,SVGFEOffsetElement:true,SVGFEPointLightElement:true,SVGFESpecularLightingElement:true,SVGFESpotLightElement:true,SVGFETileElement:true,SVGFETurbulenceElement:true,SVGFilterElement:true,SVGForeignObjectElement:true,SVGGElement:true,SVGGeometryElement:true,SVGGraphicsElement:true,SVGImageElement:true,SVGLineElement:true,SVGLinearGradientElement:true,SVGMarkerElement:true,SVGMaskElement:true,SVGMetadataElement:true,SVGPathElement:true,SVGPatternElement:true,SVGPolygonElement:true,SVGPolylineElement:true,SVGRadialGradientElement:true,SVGRectElement:true,SVGScriptElement:true,SVGSetElement:true,SVGStopElement:true,SVGStyleElement:true,SVGElement:true,SVGSVGElement:true,SVGSwitchElement:true,SVGSymbolElement:true,SVGTSpanElement:true,SVGTextContentElement:true,SVGTextElement:true,SVGTextPathElement:true,SVGTextPositioningElement:true,SVGTitleElement:true,SVGUseElement:true,SVGViewElement:true,SVGGradientElement:true,SVGComponentTransferFunctionElement:true,SVGFEDropShadowElement:true,SVGMPathElement:true,Element:false,AbortPaymentEvent:true,AnimationEvent:true,AnimationPlaybackEvent:true,ApplicationCacheErrorEvent:true,BackgroundFetchClickEvent:true,BackgroundFetchEvent:true,BackgroundFetchFailEvent:true,BackgroundFetchedEvent:true,BeforeInstallPromptEvent:true,BeforeUnloadEvent:true,BlobEvent:true,CanMakePaymentEvent:true,ClipboardEvent:true,CloseEvent:true,CustomEvent:true,DeviceMotionEvent:true,DeviceOrientationEvent:true,ErrorEvent:true,ExtendableEvent:true,ExtendableMessageEvent:true,FetchEvent:true,FontFaceSetLoadEvent:true,ForeignFetchEvent:true,GamepadEvent:true,HashChangeEvent:true,InstallEvent:true,MediaEncryptedEvent:true,MediaKeyMessageEvent:true,MediaQueryListEvent:true,MediaStreamEvent:true,MediaStreamTrackEvent:true,MessageEvent:true,MIDIConnectionEvent:true,MIDIMessageEvent:true,MutationEvent:true,NotificationEvent:true,PageTransitionEvent:true,PaymentRequestEvent:true,PaymentRequestUpdateEvent:true,PopStateEvent:true,PresentationConnectionAvailableEvent:true,PresentationConnectionCloseEvent:true,ProgressEvent:true,PromiseRejectionEvent:true,PushEvent:true,RTCDataChannelEvent:true,RTCDTMFToneChangeEvent:true,RTCPeerConnectionIceEvent:true,RTCTrackEvent:true,SecurityPolicyViolationEvent:true,SensorErrorEvent:true,SpeechRecognitionError:true,SpeechRecognitionEvent:true,SpeechSynthesisEvent:true,StorageEvent:true,SyncEvent:true,TrackEvent:true,TransitionEvent:true,WebKitTransitionEvent:true,VRDeviceEvent:true,VRDisplayEvent:true,VRSessionEvent:true,MojoInterfaceRequestEvent:true,ResourceProgressEvent:true,USBConnectionEvent:true,IDBVersionChangeEvent:true,AudioProcessingEvent:true,OfflineAudioCompletionEvent:true,WebGLContextEvent:true,Event:false,InputEvent:false,Window:true,DOMWindow:true,EventTarget:false,HTMLFormElement:true,HTMLDocument:true,HTMLImageElement:true,HTMLAudioElement:true,HTMLMediaElement:false,MouseEvent:true,DragEvent:true,PointerEvent:true,WheelEvent:true,Node:false,HTMLSelectElement:true,CompositionEvent:true,FocusEvent:true,KeyboardEvent:true,TextEvent:true,TouchEvent:true,UIEvent:false,HTMLVideoElement:true})})()
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!='undefined'){a(document.currentScript)
return}var u=document.scripts
function onLoad(b){for(var s=0;s<u.length;++s)u[s].removeEventListener("load",onLoad,false)
a(b.target)}for(var t=0;t<u.length;++t)u[t].addEventListener("load",onLoad,false)})(function(a){v.currentScript=a
if(typeof dartMainRunner==="function")dartMainRunner(X.cv,[])
else X.cv([])})})()
//# sourceMappingURL=imageutil.dart.js.map
