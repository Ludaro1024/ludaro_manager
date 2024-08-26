import{_ as V,r as l,o as A,a as i,c as d,b as e,t as n,F,d as G,w as b,v as h,e as m}from"./index-DewJNQIB.js";const R={key:0,class:"loading-message"},D={key:1,class:"container mx-auto p-4"},J={class:"society-list-container overflow-y-auto max-h-[70vh]"},B={class:"society-table w-full table-auto"},W={class:"px-4 py-2 text-white"},I={class:"px-4 py-2 text-white"},L={class:"px-4 py-2 text-white"},q={class:"px-4 py-2 text-white"},z={class:"px-4 py-2"},H={class:"px-4 py-2"},K={class:"px-4 py-2"},Q={class:"px-4 py-2"},X=["onClick"],Y=["onClick"],Z=["onClick"],ee={key:2,class:"popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75"},te={class:"popup-content bg-gray-800 text-white p-4 rounded w-1/2"},oe={class:"text-lg font-bold mb-4"},se={class:"mt-4"},ne={key:3,class:"popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75"},ae={class:"popup-content bg-gray-800 text-white p-4 rounded w-1/2"},le={class:"text-lg font-bold mb-4"},re={class:"mt-4"},ie={key:4,class:"popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75"},de={class:"popup-content bg-gray-800 text-white p-4 rounded w-1/2"},ce={class:"text-lg font-bold mb-4"},ue={class:"mt-4"},pe={key:5,class:"popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75"},ye={class:"popup-content bg-gray-800 text-white p-4 rounded w-1/2"},be={class:"text-lg font-bold mb-4"},he={class:"mb-4"},ge={class:"block mb-2"},ve={class:"mb-4"},me={class:"block mb-2"},we={class:"mb-4"},fe={class:"block mb-2"},_e={class:"mt-4"},xe={__name:"society",setup($e){const $=l(!0),p=l([]),w=l(!1),f=l(!1),_=l(!1),x=l(!1),r=l(0),g=l(null),y=l(null),c=l({name:"",label:"",money:0}),k=async()=>{try{const s=await(await fetch(`https://${GetParentResourceName()}/getSocietys`)).json();p.value=s[0]}catch(t){console.error("Error fetching societies:",t)}finally{$.value=!1}},S=(t,s)=>{const o=p.value.find(a=>a.name===t);o&&(o.money=s)},C=async(t,s)=>{try{const a=await(await fetch(`https://${GetParentResourceName()}/depositSocietyMoney`,{method:"POST",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify({society:t,amount:s})})).json();if(a.success){const v=p.value.find(O=>O.name===t);v&&(v.money+=s),u()}else console.error("Error depositing money:",a.error)}catch(o){console.error("Error depositing money:",o)}},P=async(t,s)=>{try{const o=p.value.find(a=>a.name===t);if(o&&o.money>=s){const v=await(await fetch(`https://${GetParentResourceName()}/withdrawSocietyMoney`,{method:"POST",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify({society:t,amount:s})})).json();v.success?(o.money-=s,u()):console.error("Error withdrawing money:",v.error)}}catch(o){console.error("Error withdrawing money:",o)}},N=async(t,s)=>{try{(await(await fetch(`https://${GetParentResourceName()}/setSocietyMoney`,{method:"POST",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify({society:t,amount:s})})).json()).success&&(S(t,s),u())}catch(o){console.error("Error setting society money:",o)}},j=t=>{g.value=t,r.value=0,w.value=!0},T=t=>{g.value=t,r.value=0,f.value=!0},M=t=>{y.value={...t},_.value=!0},E=()=>{x.value=!0},U=async()=>{try{const s=await(await fetch(`https://${GetParentResourceName()}/addSociety`,{method:"POST",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify(c.value)})).json();s.success&&(p.value.push(s.society),u(),c.value={name:"",label:"",money:0})}catch(t){console.error("Error adding society:",t)}},u=()=>{w.value=!1,f.value=!1,_.value=!1,x.value=!1,r.value=0,g.value=null,y.value=null};return A(()=>{k()}),(t,s)=>(i(),d("div",null,[$.value?(i(),d("div",R,[e("span",null,n(t.$t("loading")),1)])):(i(),d("div",D,[e("div",J,[e("table",B,[e("thead",null,[e("tr",null,[e("th",W,n(t.$t("name")),1),e("th",I,n(t.$t("label")),1),e("th",L,n(t.$t("money")),1),e("th",q,n(t.$t("actions")),1)])]),e("tbody",null,[(i(!0),d(F,null,G(p.value,o=>(i(),d("tr",{key:o.name,class:"cursor-pointer hover:bg-gray-700 text-white"},[e("td",z,n(o.name),1),e("td",H,n(o.label),1),e("td",K,n(o.money),1),e("td",Q,[e("button",{onClick:a=>j(o.name),class:"bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600"},n(t.$t("deposit")),9,X),e("button",{onClick:a=>T(o.name),class:"bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600"},n(t.$t("withdraw")),9,Y),e("button",{onClick:a=>M(o),class:"bg-blue-500 text-white px-2 py-1 rounded hover:bg-blue-600"},n(t.$t("edit")),9,Z)])]))),128))])])]),e("button",{class:"add-society-button mt-4 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600",onClick:E},n(t.$t("addNewSociety")),1)])),w.value?(i(),d("div",ee,[e("div",te,[e("h3",oe,n(t.$t("depositMoney")),1),b(e("input",{type:"number","onUpdate:modelValue":s[0]||(s[0]=o=>r.value=o),class:"w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"{{ $t('enterAmount') }}"},null,512),[[h,r.value,void 0,{number:!0}]]),e("div",se,[e("button",{onClick:s[1]||(s[1]=o=>C(g.value,r.value)),class:"bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"},n(t.$t("deposit")),1),e("button",{onClick:u,class:"bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2"},n(t.$t("cancel")),1)])])])):m("",!0),f.value?(i(),d("div",ne,[e("div",ae,[e("h3",le,n(t.$t("withdrawMoney")),1),b(e("input",{type:"number","onUpdate:modelValue":s[2]||(s[2]=o=>r.value=o),class:"w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"{{ $t('enterAmount') }}"},null,512),[[h,r.value,void 0,{number:!0}]]),e("div",re,[e("button",{onClick:s[3]||(s[3]=o=>P(g.value,r.value)),class:"bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"},n(t.$t("withdraw")),1),e("button",{onClick:u,class:"bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2"},n(t.$t("cancel")),1)])])])):m("",!0),_.value?(i(),d("div",ie,[e("div",de,[e("h3",ce,n(t.$t("editMoney")),1),b(e("input",{type:"number","onUpdate:modelValue":s[4]||(s[4]=o=>y.value.money=o),class:"w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"{{ $t('enterAmount') }}"},null,512),[[h,y.value.money,void 0,{number:!0}]]),e("div",ue,[e("button",{onClick:s[5]||(s[5]=o=>N(y.value.name,y.value.money)),class:"bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"},n(t.$t("save")),1),e("button",{onClick:u,class:"bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2"},n(t.$t("cancel")),1)])])])):m("",!0),x.value?(i(),d("div",pe,[e("div",ye,[e("h3",be,n(t.$t("addNewSociety")),1),e("div",he,[e("label",ge,n(t.$t("societyName")),1),b(e("input",{type:"text","onUpdate:modelValue":s[6]||(s[6]=o=>c.value.name=o),class:"w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white"},null,512),[[h,c.value.name]])]),e("div",ve,[e("label",me,n(t.$t("label")),1),b(e("input",{type:"text","onUpdate:modelValue":s[7]||(s[7]=o=>c.value.label=o),class:"w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white"},null,512),[[h,c.value.label]])]),e("div",we,[e("label",fe,n(t.$t("money")),1),b(e("input",{type:"number","onUpdate:modelValue":s[8]||(s[8]=o=>c.value.money=o),class:"w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white"},null,512),[[h,c.value.money]])]),e("div",_e,[e("button",{onClick:U,class:"bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"},n(t.$t("addSociety")),1),e("button",{onClick:u,class:"bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2"},n(t.$t("cancel")),1)])])])):m("",!0)]))}},Se=V(xe,[["__scopeId","data-v-9878eeb4"]]);export{Se as default};
