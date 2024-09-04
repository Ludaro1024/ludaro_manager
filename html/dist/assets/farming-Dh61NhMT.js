import{r as p,a as r,c as i,b as e,t as a,F as h,d as y,e as v,g,w as d,v as m,j as w,h as S}from"./index-ByNToXAh.js";const E={key:0,class:"farming-management-container"},H={class:"farming-management-container"},K={class:"text-2xl font-bold mb-4 text-white"},Q={key:0},W={class:"text-white mb-4"},X={key:1},Y={class:"flex justify-between items-center"},Z=["onClick"],ee={class:"text-lg font-bold mb-2 text-white"},te={class:"text-sm text-gray-400"},oe=["onClick"],se={key:2,class:"modal-overlay"},ne={class:"modal-content"},ae={class:"text-lg font-bold mb-2 text-white"},le={key:0,class:"text-red-500 mb-4"},re={class:"mb-4"},ie={class:"block mb-2 text-white"},de=e("span",{class:"text-red-500"},"*",-1),ue={class:"mb-4"},ce={class:"block mb-2 text-white"},me=e("span",{class:"text-red-500"},"*",-1),pe={class:"coords-input-group"},be={class:"mb-4"},ve={class:"block mb-2 text-white"},ge=e("span",{class:"text-red-500"},"*",-1),he={value:"none"},ye=["value"],fe={class:"block mb-2 text-white"},we=e("span",{class:"text-red-500"},"*",-1),_e={class:"mb-4"},xe={class:"block mb-2 text-white"},$e=e("span",{class:"text-red-500"},"*",-1),ke={value:"none"},Ce=["value"],Ve={class:"mb-4"},Ie={class:"block mb-2 text-white"},Se=e("span",{class:"text-red-500"},"*",-1),Fe={class:"mb-4"},Ue={class:"block mb-2 text-white"},Ne={class:"mb-4"},Oe={class:"block mb-2 text-white"},Te=e("span",{class:"text-red-500"},"*",-1),je=["onUpdate:modelValue"],Me=["onUpdate:modelValue"],Pe=["onClick"],ze={class:"mb-4"},Ae={class:"block mb-2 text-white"},Ge=e("span",{class:"text-red-500"},"*",-1),Le=["onUpdate:modelValue"],Je=["onUpdate:modelValue"],Be=["onClick"],Re={class:"mb-4"},qe={class:"block mb-2 text-white"},De={key:0},Ee={class:"block mb-2 text-white"},He={value:"money"},Ke={value:"bank"},Qe={value:"black_money"},We={class:"block mb-2 text-white"},Xe={value:"none"},Ye=["value"],Ze={key:1},et={class:"block mb-2 text-white"},tt={class:"mb-4"},ot={class:"block mb-2 text-white"},st={class:"mb-4"},nt={class:"block mb-2 text-white"},at={key:0},lt={class:"block mb-2 text-white"},rt=["onUpdate:modelValue"],it=["onUpdate:modelValue"],dt=["onUpdate:modelValue"],ut=["onClick"],ct={key:1,class:"text-red-500 mb-4"},mt={key:1,class:"under-construction"},pt={class:"message"},bt={class:"text"},vt=e("br",null,null,-1),gt={class:"text"},ft={__name:"farming",setup(ht){const x=p(!1),$=p(0),F=async()=>{try{const s=await(await fetch(`https://${GetParentResourceName()}/GetDebugLevel`,{method:"POST",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify({})})).json();$.value=s.DebugLevel||0,$.value>3&&U()}catch(o){console.error("Failed to fetch debug level:",o)}},U=()=>{x.value=!0,N(),O(),T(),j()},b=p([]),t=p(null),f=p(!1),k=p([]),C=p([]),V=p([]),l=p(""),N=async()=>{try{const s=await(await fetch(`https://${GetParentResourceName()}/getFarmingSpots`)).json();b.value=s.farmingSpots||[]}catch(o){console.error("Failed to fetch farming spots:",o)}},O=async()=>{try{const s=await(await fetch(`https://${GetParentResourceName()}/getJobs`)).json();k.value=s.jobs||[]}catch(o){console.error("Failed to fetch jobs:",o)}},T=async()=>{try{const s=await(await fetch(`https://${GetParentResourceName()}/getAnimations`)).json();C.value=s.animations||[]}catch(o){console.error("Failed to fetch animations:",o)}},j=async()=>{try{const s=await(await fetch(`https://${GetParentResourceName()}/getSocieties`)).json();V.value=s.societies||[]}catch(o){console.error("Failed to fetch societies:",o)}},_=(o=null)=>{l.value="",o!==null?(t.value={...b.value[o]},t.value.coords=t.value.coords||{x:0,y:0,z:0},t.value.itemsIn=t.value.itemsIn||[],t.value.itemsOut=t.value.itemsOut||[],t.value.additionalCoords=t.value.additionalCoords||[]):t.value={name:"",coords:{x:0,y:0,z:0},job:"",grade:0,animation:"",customAnimation:"",time:0,progressBar:!1,itemsIn:[],itemsOut:[],moneyNeeded:0,moneyType:"money",society:"none",societyPercentage:0,customCode:"",multiLocation:!1,additionalCoords:[]},f.value=!0},M=()=>{if(l.value="",!t.value.name){l.value="Name is required.";return}if(!t.value.coords.x||!t.value.coords.y||!t.value.coords.z){l.value="Coordinates are required.";return}if(!t.value.job){l.value="Job is required.";return}if(t.value.itemsIn.length===0){l.value="At least one Item In is required.";return}if(t.value.itemsOut.length===0){l.value="At least one Item Out is required.";return}P()},I=()=>{t.value=null,f.value=!1},P=async()=>{const o={name:"",coords:{x:0,y:0,z:0},job:"none",grade:0,animation:"none",customAnimation:"",time:0,progressBar:!1,itemsIn:[],itemsOut:[],moneyNeeded:0,moneyType:"money",society:"none",societyPercentage:0,customCode:"",multiLocation:!1,additionalCoords:[]},s={...o,...t.value,coords:{...o.coords,...t.value.coords},itemsIn:t.value.itemsIn.length>0?t.value.itemsIn:o.itemsIn,itemsOut:t.value.itemsOut.length>0?t.value.itemsOut:o.itemsOut,additionalCoords:t.value.additionalCoords.length>0?t.value.additionalCoords:o.additionalCoords};if(!s.name){l.value=$t("errorMissingName"),console.log("Validation failed: Name is missing");return}if(!s.coords.x||!s.coords.y||!s.coords.z){l.value=$t("errorMissingCoordinates"),console.log("Validation failed: Coordinates are incomplete","x:",s.coords.x,"y:",s.coords.y,"z:",s.coords.z);return}if(!s.job){l.value=$t("errorMissingJob"),console.log("Validation failed: Job is missing");return}if(!s.grade){l.value=$t("errorMissingGrade"),console.log("Validation failed: Grade is missing");return}if(!s.animation){l.value=$t("errorMissingAnimation"),console.log("Validation failed: Animation is missing");return}if(!s.time){l.value=$t("errorMissingTime"),console.log("Validation failed: Time is missing");return}if(s.itemsIn.length===0){l.value=$t("errorMissingItemsIn"),console.log("Validation failed: No Items In specified");return}if(s.itemsOut.length===0){l.value=$t("errorMissingItemsOut"),console.log("Validation failed: No Items Out specified");return}if(s.moneyNeeded>0&&!s.moneyType){l.value=$t("errorMissingMoneyType"),console.log("Validation failed: Money type must be specified if money is needed");return}if(s.society!=="none"&&s.societyPercentage===0){l.value=$t("errorMissingSocietyPercentage"),console.log("Validation failed: Society percentage must be specified if society is set");return}if(s.moneyNeeded>0&&!s.moneyType){l.value="Money type must be specified if money is needed.";return}if(s.society!=="none"&&s.societyPercentage===0){l.value="Society percentage must be specified if society is set.";return}try{const u=await(await fetch(`https://${GetParentResourceName()}/saveFarmingSpot`,{method:"POST",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify({farmingSpot:s})})).json();if(u.success){if(t.value.id){const c=b.value.findIndex(D=>D.id===t.value.id);c!==-1&&(b.value[c]=u.farmingSpot)}else b.value.push(u.farmingSpot);I()}else l.value="Failed to save farming spot: "+u.error,console.error("Failed to save farming spot:",u.error)}catch(n){l.value="An error occurred while saving the farming spot.",console.error("Failed to save farming spot:",n)}},z=async o=>{const s=b.value[o].id;try{const u=await(await fetch(`https://${GetParentResourceName()}/deleteFarmingSpot`,{method:"POST",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify({id:s})})).json();u.success?b.value.splice(o,1):(l.value="Failed to delete farming spot: "+u.error,console.error("Failed to delete farming spot:",u.error))}catch(n){l.value="An error occurred while deleting the farming spot.",console.error("Failed to delete farming spot:",n)}},A=async()=>{try{const s=await(await fetch(`https://${GetParentResourceName()}/getCurrentCoords`,{method:"POST",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify({})})).json();s&&(t.value.coords={x:s.x,y:s.y,z:s.z})}catch(o){console.error("Failed to fetch current coords:",o)}},G=()=>{t.value.itemsIn||(t.value.itemsIn=[]),t.value.itemsIn.push({name:"",count:0})},L=o=>{t.value.itemsIn.splice(o,1)},J=()=>{t.value.itemsOut||(t.value.itemsOut=[]),t.value.itemsOut.push({name:"",count:0})},B=o=>{t.value.itemsOut.splice(o,1)},R=()=>{t.value.additionalCoords||(t.value.additionalCoords=[]),t.value.additionalCoords.push({x:0,y:0,z:0})},q=o=>{t.value.additionalCoords.splice(o,1)};return F(),(o,s)=>x.value?(r(),i("div",E,[e("div",H,[e("h2",K,a(o.$t("farmingSpots")),1),f.value?f.value?v("",!0):(r(),i("div",X,[e("button",{onClick:_,class:"bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 mb-4"},a(o.$t("createNewFarmingSpot")),1),(r(!0),i(h,null,y(b.value,(n,u)=>(r(),i("div",{key:u,class:"mb-4 p-4 border border-gray-600 rounded bg-gray-800"},[e("div",Y,[e("div",{onClick:c=>_(u),class:"cursor-pointer"},[e("h3",ee,a(n.name||o.$t("unnamedFarmingSpot")),1),e("p",te,a(o.$t("clickToEdit")),1)],8,Z),e("button",{onClick:c=>z(u),class:"bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"},a(o.$t("delete")),9,oe)])]))),128))])):(r(),i("div",Q,[e("p",W,a(o.$t("noFarmingSpots")),1),e("button",{onClick:_,class:"bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"},a(o.$t("createNewFarmingSpot")),1)])),f.value?(r(),i("div",se,[e("div",ne,[e("h3",ae,a(t.value.name||o.$t("newFarmingSpot")),1),l.value?(r(),i("div",le,a(l.value),1)):v("",!0),e("div",re,[e("label",ie,[g(a(o.$t("spotName")),1),de]),d(e("input",{type:"text","onUpdate:modelValue":s[0]||(s[0]=n=>t.value.name=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white"},null,512),[[m,t.value.name]])]),e("div",ue,[e("label",ce,[g(a(o.$t("coords"))+" (x, y, z)",1),me]),e("div",pe,[d(e("input",{type:"number","onUpdate:modelValue":s[1]||(s[1]=n=>t.value.coords.x=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"x"},null,512),[[m,t.value.coords.x]]),d(e("input",{type:"number","onUpdate:modelValue":s[2]||(s[2]=n=>t.value.coords.y=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"y"},null,512),[[m,t.value.coords.y]]),d(e("input",{type:"number","onUpdate:modelValue":s[3]||(s[3]=n=>t.value.coords.z=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"z"},null,512),[[m,t.value.coords.z]])]),e("button",{onClick:A,class:"bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2"},a(o.$t("useCurrentCoords")),1)]),e("div",be,[e("label",ve,[g(a(o.$t("requiredJob")),1),ge]),d(e("select",{"onUpdate:modelValue":s[4]||(s[4]=n=>t.value.job=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white"},[e("option",he,a(o.$t("none")),1),(r(!0),i(h,null,y(k.value,n=>(r(),i("option",{key:n.name,value:n.name},a(n.label),9,ye))),128))],512),[[w,t.value.job]]),e("label",fe,[g(a(o.$t("requiredGrade")),1),we]),d(e("input",{type:"number","onUpdate:modelValue":s[5]||(s[5]=n=>t.value.grade=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white",min:"0",value:"0"},null,512),[[m,t.value.grade]])]),e("div",_e,[e("label",xe,[g(a(o.$t("animation")),1),$e]),d(e("select",{"onUpdate:modelValue":s[6]||(s[6]=n=>t.value.animation=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white"},[e("option",ke,a(o.$t("noAnimation")),1),(r(!0),i(h,null,y(C.value,n=>(r(),i("option",{key:n.name,value:n.name},a(n.label),9,Ce))),128))],512),[[w,t.value.animation]]),t.value.animation==="custom"?d((r(),i("input",{key:0,type:"text","onUpdate:modelValue":s[7]||(s[7]=n=>t.value.customAnimation=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"Custom Animation"},null,512)),[[m,t.value.customAnimation]]):v("",!0)]),e("div",Ve,[e("label",Ie,[g(a(o.$t("timeInSeconds")),1),Se]),d(e("input",{type:"number","onUpdate:modelValue":s[8]||(s[8]=n=>t.value.time=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white"},null,512),[[m,t.value.time]])]),e("div",Fe,[e("label",Ue,a(o.$t("progressBar")),1),d(e("input",{type:"checkbox","onUpdate:modelValue":s[9]||(s[9]=n=>t.value.progressBar=n)},null,512),[[S,t.value.progressBar]])]),e("div",Ne,[e("label",Oe,[g(a(o.$t("itemsIn")),1),Te]),(r(!0),i(h,null,y(t.value.itemsIn,(n,u)=>(r(),i("div",{key:u,class:"flex mb-2"},[d(e("input",{type:"text","onUpdate:modelValue":c=>n.name=c,class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white mr-2",placeholder:"Item Name"},null,8,je),[[m,n.name]]),d(e("input",{type:"number","onUpdate:modelValue":c=>n.count=c,class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"Count"},null,8,Me),[[m,n.count]]),e("button",{onClick:c=>L(u),class:"bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600"},a(o.$t("remove")),9,Pe)]))),128)),e("button",{onClick:G,class:"bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"},a(o.$t("addItemIn")),1)]),e("div",ze,[e("label",Ae,[g(a(o.$t("itemsOut")),1),Ge]),(r(!0),i(h,null,y(t.value.itemsOut,(n,u)=>(r(),i("div",{key:u,class:"flex mb-2"},[d(e("input",{type:"text","onUpdate:modelValue":c=>n.name=c,class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white mr-2",placeholder:"Item Name"},null,8,Le),[[m,n.name]]),d(e("input",{type:"number","onUpdate:modelValue":c=>n.count=c,class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"Count"},null,8,Je),[[m,n.count]]),e("button",{onClick:c=>B(u),class:"bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600"},a(o.$t("remove")),9,Be)]))),128)),e("button",{onClick:J,class:"bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"},a(o.$t("addItemOut")),1)]),e("div",Re,[e("label",qe,a(o.$t("moneyNeeded")),1),d(e("input",{type:"number","onUpdate:modelValue":s[10]||(s[10]=n=>t.value.moneyNeeded=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white"},null,512),[[m,t.value.moneyNeeded]]),t.value.moneyNeeded>0?(r(),i("div",De,[e("label",Ee,a(o.$t("moneyType")),1),d(e("select",{"onUpdate:modelValue":s[11]||(s[11]=n=>t.value.moneyType=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white"},[e("option",He,a(o.$t("cash")),1),e("option",Ke,a(o.$t("bank")),1),e("option",Qe,a(o.$t("blackMoney")),1)],512),[[w,t.value.moneyType]])])):v("",!0),e("label",We,a(o.$t("society")),1),d(e("select",{"onUpdate:modelValue":s[12]||(s[12]=n=>t.value.society=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white"},[e("option",Xe,a(o.$t("none")),1),(r(!0),i(h,null,y(V.value,n=>(r(),i("option",{key:n.name,value:n.name},a(n.label),9,Ye))),128))],512),[[w,t.value.society]]),t.value.society!=="none"?(r(),i("div",Ze,[e("label",et,a(o.$t("societyPercentage")),1),d(e("input",{type:"number","onUpdate:modelValue":s[13]||(s[13]=n=>t.value.societyPercentage=n),min:"0",max:"100",class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"Percentage"},null,512),[[m,t.value.societyPercentage]])])):v("",!0)]),e("div",tt,[e("label",ot,a(o.$t("customCode")),1),d(e("textarea",{"onUpdate:modelValue":s[14]||(s[14]=n=>t.value.customCode=n),class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"Custom Code"},null,512),[[m,t.value.customCode]])]),e("div",st,[e("label",nt,a(o.$t("multiLocation")),1),d(e("input",{type:"checkbox","onUpdate:modelValue":s[15]||(s[15]=n=>t.value.multiLocation=n)},null,512),[[S,t.value.multiLocation]]),t.value.multiLocation?(r(),i("div",at,[e("label",lt,a(o.$t("additionalCoords"))+" (x, y, z)",1),(r(!0),i(h,null,y(t.value.additionalCoords,(n,u)=>(r(),i("div",{key:u,class:"flex mb-2"},[d(e("input",{type:"number","onUpdate:modelValue":c=>n.x=c,class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white mr-2",placeholder:"x"},null,8,rt),[[m,n.x]]),d(e("input",{type:"number","onUpdate:modelValue":c=>n.y=c,class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white mr-2",placeholder:"y"},null,8,it),[[m,n.y]]),d(e("input",{type:"number","onUpdate:modelValue":c=>n.z=c,class:"w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"z"},null,8,dt),[[m,n.z]]),e("button",{onClick:c=>q(u),class:"bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600"},a(o.$t("remove")),9,ut)]))),128)),e("button",{onClick:R,class:"bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"},a(o.$t("addAdditionalCoord")),1)])):v("",!0)]),e("button",{onClick:M,class:"bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"},a(o.$t("saveFarmingSpot")),1),e("button",{onClick:I,class:"bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 mt-4"},a(o.$t("cancel")),1),l.value?(r(),i("div",ct,a(l.value),1)):v("",!0)])])):v("",!0)])])):(r(),i("div",mt,[e("div",pt,[e("span",bt,a(o.$t("underConstruction")),1),vt,e("span",gt,a(o.$t("unavailable")),1)])]))}};export{ft as default};
