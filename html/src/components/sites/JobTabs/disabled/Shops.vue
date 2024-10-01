<template>
  <div class="overflow-y-auto max-h-[50vh]">
    <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
      <thead>
        <tr>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('coords') }}</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('name') }}</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('items') }}</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('actions') }}</th>
        </tr>
      </thead>
      <tbody class="bg-gray-700 divide-y divide-gray-600">
        <tr v-for="(shop, index) in job.shops" :key="index">
          <td class="px-4 py-2">
            <input type="number" v-model="shop.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
            <input type="number" v-model="shop.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
            <input type="number" v-model="shop.coords.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
            <button @click="fetchCurrentCoords(index)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentCoords') }}</button>
          </td>
          <td class="px-4 py-2">
            <input type="text" v-model="shop.name" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('shopName') }}">
          </td>
          <td class="px-4 py-2">
            <div v-for="(item, itemIndex) in shop.items" :key="itemIndex" class="mb-4">
              <input type="text" v-model="item.name" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('itemName') }}">
              <div class="flex space-x-2">
                <div class="w-1/3">
                  <label class="block mb-2">{{ $t('price') }}</label>
                  <input type="number" v-model="item.price" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('price') }}">
                </div>
                <div class="w-1/3">
                  <label class="block mb-2">{{ $t('stock') }}</label>
                  <input type="number" v-model="item.stock" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('stock') }}">
                </div>
                <div class="w-1/3">
                  <label class="block mb-2">{{ $t('grade') }}</label>
                  <select v-model="item.minimumGrade" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
                    <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
                      {{ grade.label }} (ID: {{ grade.grade }})
                    </option>
                  </select>
                </div>
              </div>
              <button @click="removeItem(index, itemIndex)" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">{{ $t('removeItem') }}</button>
            </div>
            <button @click="addItem(index)" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600">{{ $t('addItem') }}</button>
          </td>
          <td class="px-4 py-2">
            <button @click="removeShop(index)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">{{ $t('removeShop') }}</button>
          </td>
        </tr>
      </tbody>
    </table>
    <button @click="showAddShopPopup = true" class="mt-2 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">{{ $t('addShop') }}</button>

    <!-- Add Shop Popup -->
    <div v-if="showAddShopPopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2 overflow-auto max-h-[90vh]">
        <h3 class="text-lg font-bold mb-4">{{ $t('addNewShop') }}</h3>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('coords') }}</label>
          <input type="number" v-model="newShop.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
          <input type="number" v-model="newShop.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
          <input type="number" v-model="newShop.coords.z" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
          <button @click="fetchCurrentCoords(null, true)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentCoords') }}</button>
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('name') }}</label>
          <input type="text" v-model="newShop.name" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('shopName') }}">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('items') }}</label>
          <div v-for="(item, index) in newShop.items" :key="index" class="mb-4">
            <input type="text" v-model="item.name" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('itemName') }}">
            <div class="flex space-x-2">
              <div class="w-1/3">
                <label class="block mb-2">{{ $t('price') }}</label>
                <input type="number" v-model="item.price" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('price') }}">
              </div>
              <div class="w-1/3">
                <label class="block mb-2">{{ $t('stock') }}</label>
                <input type="number" v-model="item.stock" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('stock') }}">
              </div>
              <div class="w-1/3">
                <label class="block mb-2">{{ $t('grade') }}</label>
                <select v-model="item.minimumGrade" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
                  <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
                    {{ grade.label }} (ID: {{ grade.grade }})
                  </option>
                </select>
              </div>
            </div>
            <button @click="removeNewItem(index)" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">{{ $t('removeItem') }}</button>
          </div>
          <button @click="addNewItem" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600">{{ $t('addItem') }}</button>
        </div>
        <div class="mt-4">
          <button @click="addNewShop" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">{{ $t('addShop') }}</button>
          <button @click="showAddShopPopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">{{ $t('cancel') }}</button>
        </div>
      </div>
    </div>
  </div>
</template>


<script>
export default {
  props: ['job'],
  data() {
    return {
      showAddShopPopup: false,
      newShop: {
        coords: { x: 0, y: 0, z: 0 },
        name: '',
        items: []
      }
    };
  },
  beforeMount() {
  },
  methods: {
    fetchCurrentCoords(index = null, isNew = false) {
      fetch(`https://${GetParentResourceName()}/getCurrentCoords`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({})
      })
      .then((response) => response.json())
      .then((coords) => {
        if (coords) {
          if (isNew) {
            this.newShop.coords = { x: coords.x, y: coords.y, z: coords.z };
          } else {
            this.job.shops[index].coords = { x: coords.x, y: coords.y, z: coords.z };
          }
          // ;
          this.$emit('update-job', this.job);
        }
      })
      .catch((error) => {
        console.error('Failed to fetch current coords:', error);
      });
    },
    addItem(shopIndex) {
      if (!this.job.shops[shopIndex].items) {
        this.job.shops[shopIndex].items = [];
      }
      this.job.shops[shopIndex].items.push({
        name: '',
        price: 0,
        stock: 0,
        minimumGrade: ''
      });
      // ;
      this.$emit('update-job', this.job);
    },
    removeItem(shopIndex, itemIndex) {
      this.job.shops[shopIndex].items.splice(itemIndex, 1);
      // ;
      this.$emit('update-job', this.job);
    },
    addNewItem() {
      this.newShop.items.push({
        name: '',
        price: 0,
        stock: 0,
        minimumGrade: ''
      });
      // ;
    },
    removeNewItem(index) {
      this.newShop.items.splice(index, 1);
      // ;
    },
    addNewShop() {
      if (!Array.isArray(this.job.shops)) {
        this.job.shops = [];
      }
      this.job.shops.push({ ...this.newShop });
      // ;
      this.showAddShopPopup = false;
      this.newShop = {
        coords: { x: 0, y: 0, z: 0 },
        name: '',
        items: []
      };
      this.$emit('update-job', this.job);
    },
    removeShop(index) {
      this.job.shops.splice(index, 1);
      // ;
      this.$emit('update-job', this.job);
    }
  }
};


</script>