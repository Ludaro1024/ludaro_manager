import{_ as y,a as d,c as a,b as e,t as l,w as n,v as c,h as u,F as m,d as g,e as b}from"./index-ex7GC6sz.js";const w={data(){return{vehicles:[],filteredVehicles:[],searchQuery:"",sortKey:"plate",selectedVehicle:null,showWarningPopup:!1,loading:!0}},mounted(){this.fetchVehicles()},methods:{async fetchVehicles(){try{const s=await(await fetch(`https://${GetParentResourceName()}/getVehicles`,{method:"POST",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify({})})).json();this.vehicles=s.vehicles,this.filteredVehicles=[...this.vehicles]}catch(t){console.error("Failed to fetch vehicles:",t)}finally{this.loading=!1}},filterVehicles(){const t=this.searchQuery.toLowerCase();this.filteredVehicles=this.vehicles.filter(s=>s.plate.toLowerCase().includes(t)||s.model.toLowerCase().includes(t)||s.name.toLowerCase().includes(t))},sortVehicles(){this.filteredVehicles.sort((t,s)=>t[this.sortKey]<s[this.sortKey]?-1:t[this.sortKey]>s[this.sortKey]?1:0)},editVehicle(t){this.selectedVehicle={oldPlate:t.plate,newPlate:t.plate,newModel:t.model,newOwner:t.owner,name:t.name,newJob:t.job,stored:t.stored}},confirmSaveVehicle(){this.selectedVehicle.stored===0?this.showWarningPopup=!0:this.saveVehicle()},async saveVehicle(){this.showWarningPopup=!1;try{const s=await(await fetch(`https://${GetParentResourceName()}/editVehicle`,{method:"POST",headers:{"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify(this.selectedVehicle)})).json();if(s.success){const h=this.vehicles.findIndex(p=>p.plate===this.selectedVehicle.oldPlate);h!==-1&&(this.vehicles.splice(h,1,s.vehicle),this.filterVehicles(),this.closePopup())}else console.error("Failed to update vehicle:",s.error)}catch(t){console.error("Failed to save vehicle:",t)}},closePopup(){this.selectedVehicle=null},closeWarningPopup(){this.showWarningPopup=!1}}},f={class:"vehicle-management-container"},V={class:"text-2xl font-bold mb-4 text-white"},x={key:0,class:"text-center text-white"},v={key:1},_={class:"filter-search-bar flex justify-between mb-4"},k={value:"plate"},P={value:"model"},C={value:"job"},j={value:"stored"},N={value:"name"},O={class:"overflow-y-auto max-h-[50vh]"},S={class:"min-w-full divide-y divide-gray-200 bg-gray-800 text-white"},U={class:"px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider"},B={class:"px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider"},$={class:"px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider"},M={class:"px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider"},W={class:"px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider"},F={class:"px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider"},J={class:"bg-gray-700 divide-y divide-gray-600"},K={class:"px-4 py-2"},T={class:"px-4 py-2"},I={class:"px-4 py-2"},L={class:"px-4 py-2"},Q={class:"px-4 py-2"},D={class:"px-4 py-2"},G=["onClick"],R={key:2,class:"popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75"},q={class:"popup-content bg-gray-800 text-white p-4 rounded w-1/2"},E={class:"text-lg font-bold mb-4"},z={class:"mb-4"},A={class:"block mb-2"},H={class:"mb-4"},X={class:"block mb-2"},Y={class:"mb-4"},Z={class:"block mb-2"},ee={class:"mb-4"},te={class:"block mb-2"},se={class:"mb-4"},oe={class:"block mb-2"},le={class:"mb-4"},ie={class:"block mb-2"},re={value:"1"},ne={value:"0"},de={class:"mt-4"},ae={key:3,class:"popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75"},ce={class:"popup-content bg-gray-800 text-white p-4 rounded w-1/2"},he={class:"text-lg font-bold mb-4"},pe={class:"mb-4"},ue={class:"mt-4"};function be(t,s,h,p,i,r){return d(),a("div",f,[e("h2",V,l(t.$t("vehicleManagement")),1),i.loading?(d(),a("div",x,l(t.$t("loading"))+"... ",1)):(d(),a("div",v,[e("div",_,[n(e("input",{"onUpdate:modelValue":s[0]||(s[0]=o=>i.searchQuery=o),onInput:s[1]||(s[1]=(...o)=>r.filterVehicles&&r.filterVehicles(...o)),class:"p-2 w-1/3 rounded bg-gray-700 text-white",placeholder:"{{ $t('searchByPlateModelOrName') }}"},null,544),[[c,i.searchQuery]]),n(e("select",{"onUpdate:modelValue":s[2]||(s[2]=o=>i.sortKey=o),onChange:s[3]||(s[3]=(...o)=>r.sortVehicles&&r.sortVehicles(...o)),class:"p-2 rounded bg-gray-700 text-white"},[e("option",k,l(t.$t("sortByPlate")),1),e("option",P,l(t.$t("sortByModel")),1),e("option",C,l(t.$t("sortByJob")),1),e("option",j,l(t.$t("sortByParkedState")),1),e("option",N,l(t.$t("sortByOwnerName")),1)],544),[[u,i.sortKey]])]),e("div",O,[e("table",S,[e("thead",null,[e("tr",null,[e("th",U,l(t.$t("plate")),1),e("th",B,l(t.$t("model")),1),e("th",$,l(t.$t("job")),1),e("th",M,l(t.$t("ownerName")),1),e("th",W,l(t.$t("parked")),1),e("th",F,l(t.$t("actions")),1)])]),e("tbody",J,[(d(!0),a(m,null,g(i.filteredVehicles,(o,ye)=>(d(),a("tr",{key:o.plate},[e("td",K,l(o.plate),1),e("td",T,l(o.model),1),e("td",I,l(o.job),1),e("td",L,l(o.name),1),e("td",Q,l(o.stored===1?t.$t("yes"):t.$t("no")),1),e("td",D,[e("button",{onClick:me=>r.editVehicle(o),class:"bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"},l(t.$t("edit")),9,G)])]))),128))])])])])),i.selectedVehicle?(d(),a("div",R,[e("div",q,[e("h3",E,l(t.$t("editVehicle")),1),e("div",z,[e("label",A,l(t.$t("plate")),1),n(e("input",{type:"text","onUpdate:modelValue":s[4]||(s[4]=o=>i.selectedVehicle.newPlate=o),class:"w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white"},null,512),[[c,i.selectedVehicle.newPlate]])]),e("div",H,[e("label",X,l(t.$t("model")),1),n(e("input",{type:"text","onUpdate:modelValue":s[5]||(s[5]=o=>i.selectedVehicle.newModel=o),class:"w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white"},null,512),[[c,i.selectedVehicle.newModel]])]),e("div",Y,[e("label",Z,l(t.$t("ownerName")),1),n(e("input",{type:"text","onUpdate:modelValue":s[6]||(s[6]=o=>i.selectedVehicle.name=o),class:"w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"{{ $t('insertOwnerName') }}"},null,512),[[c,i.selectedVehicle.name]])]),e("div",ee,[e("label",te,l(t.$t("ownerIdentifier")),1),n(e("input",{type:"text","onUpdate:modelValue":s[7]||(s[7]=o=>i.selectedVehicle.newOwner=o),class:"w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"{{ $t('insertOwnerIdentifier') }}"},null,512),[[c,i.selectedVehicle.newOwner]])]),e("div",se,[e("label",oe,l(t.$t("job")),1),n(e("input",{type:"text","onUpdate:modelValue":s[8]||(s[8]=o=>i.selectedVehicle.newJob=o),class:"w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white",placeholder:"{{ $t('insertJob') }}"},null,512),[[c,i.selectedVehicle.newJob]])]),e("div",le,[e("label",ie,l(t.$t("parked")),1),n(e("select",{"onUpdate:modelValue":s[9]||(s[9]=o=>i.selectedVehicle.stored=o),class:"w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white"},[e("option",re,l(t.$t("yes")),1),e("option",ne,l(t.$t("no")),1)],512),[[u,i.selectedVehicle.stored]])]),e("div",de,[e("button",{onClick:s[10]||(s[10]=(...o)=>r.confirmSaveVehicle&&r.confirmSaveVehicle(...o)),class:"bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"},l(t.$t("save")),1),e("button",{onClick:s[11]||(s[11]=(...o)=>r.closePopup&&r.closePopup(...o)),class:"bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2"},l(t.$t("cancel")),1)])])])):b("",!0),i.showWarningPopup?(d(),a("div",ae,[e("div",ce,[e("h3",he,l(t.$t("warning")),1),e("p",pe,l(t.$t("warningVehicleNotParked")),1),e("div",ue,[e("button",{onClick:s[12]||(s[12]=(...o)=>r.saveVehicle&&r.saveVehicle(...o)),class:"bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"},l(t.$t("proceed")),1),e("button",{onClick:s[13]||(s[13]=(...o)=>r.closeWarningPopup&&r.closeWarningPopup(...o)),class:"bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2"},l(t.$t("cancel")),1)])])])):b("",!0)])}const we=y(w,[["render",be],["__scopeId","data-v-6c15e9aa"]]);export{we as default};