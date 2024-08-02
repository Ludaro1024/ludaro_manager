<template>
  <div class="overflow-y-auto max-h-[50vh]">
    <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
      <thead>
        <tr>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Coords</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Name</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Items</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
        </tr>
      </thead>
      <tbody class="bg-gray-700 divide-y divide-gray-600">
        <tr v-for="(shop, index) in job.shops" :key="index">
          <td class="px-4 py-2">
            <input type="number" v-model="shop.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
            <input type="number" v-model="shop.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
            <input type="number" v-model="shop.coords.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
            <button @click="fetchCurrentCoords(index)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">Use Current Coords</button>
          </td>
          <td class="px-4 py-2">
            <input type="text" v-model="shop.name" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Shop Name">
          </td>
          <td class="px-4 py-2">
            <div v-for="(item, itemIndex) in shop.items" :key="itemIndex" class="mb-4">
              <input type="text" v-model="item.name" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Item Name">
              <div class="flex space-x-2">
                <div class="w-1/3">
                  <label class="block mb-2">Price</label>
                  <input type="number" v-model="item.price" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Price">
                </div>
                <div class="w-1/3">
                  <label class="block mb-2">Stock</label>
                  <input type="number" v-model="item.stock" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Stock">
                </div>
                <div class="w-1/3">
                  <label class="block mb-2">Grade</label>
                  <select v-model="item.minimumGrade" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
                    <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
                      {{ grade.label }} (ID: {{ grade.grade }})
                    </option>
                  </select>
                </div>
              </div>
              <button @click="removeItem(index, itemIndex)" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Remove Item</button>
            </div>
            <button @click="addItem(index)" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600">Add Item</button>
          </td>
          <td class="px-4 py-2">
            <button @click="removeShop(index)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Remove Shop</button>
          </td>
        </tr>
      </tbody>
    </table>
    <button @click="showAddShopPopup = true" class="mt-2 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">Add Shop</button>

    <!-- Add Shop Popup -->
    <div v-if="showAddShopPopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2 overflow-auto max-h-[90vh]">
        <h3 class="text-lg font-bold mb-4">Add New Shop</h3>
        <div class="mb-4">
          <label class="block mb-2">Coords</label>
          <input type="number" v-model="newShop.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
          <input type="number" v-model="newShop.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
          <input type="number" v-model="newShop.coords.z" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
          <button @click="fetchCurrentCoords(null, true)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">Use Current Coords</button>
        </div>
        <div class="mb-4">
          <label class="block mb-2">Name</label>
          <input type="text" v-model="newShop.name" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Shop Name">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Items</label>
          <div v-for="(item, index) in newShop.items" :key="index" class="mb-4">
            <input type="text" v-model="item.name" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Item Name">
            <div class="flex space-x-2">
              <div class="w-1/3">
                <label class="block mb-2">Price</label>
                <input type="number" v-model="item.price" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Price">
              </div>
              <div class="w-1/3">
                <label class="block mb-2">Stock</label>
                <input type="number" v-model="item.stock" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Stock">
              </div>
              <div class="w-1/3">
                <label class="block mb-2">Grade</label>
                <select v-model="item.minimumGrade" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
                  <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
                    {{ grade.label }} (ID: {{ grade.grade }})
                  </option>
                </select>
              </div>
            </div>
            <button @click="removeNewItem(index)" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Remove Item</button>
          </div>
          <button @click="addNewItem" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600">Add Item</button>
        </div>
        <div class="mt-4">
          <button @click="addNewShop" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Shop</button>
          <button @click="showAddShopPopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
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
    this.job.shops = JSON.parse(this.job.ludaro_manager_shops || '[]');
    if (!this.job.shops) {
      this.job.shops = [];
    }
    this.job.shops = this.job.shops.map(shop => ({
      coords: shop.coords || { x: 0, y: 0, z: 0 },
      name: shop.name || '',
      items: shop.items ? shop.items.map(item => ({
        name: item.name || '',
        price: item.price || 0,
        stock: item.stock || 0,
        minimumGrade: item.minimumGrade || ''
      })) : []
    }));
    console.log('Loaded job data:', JSON.stringify(this.job.shops));
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
          console.log('Updated coords:', coords);
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
      console.log('Added new item to shop:', shopIndex, this.job.shops[shopIndex].items);
      this.$emit('update-job', this.job);
    },
    removeItem(shopIndex, itemIndex) {
      this.job.shops[shopIndex].items.splice(itemIndex, 1);
      console.log('Removed item from shop:', shopIndex, this.job.shops[shopIndex].items);
      this.$emit('update-job', this.job);
    },
    addNewItem() {
      this.newShop.items.push({
        name: '',
        price: 0,
        stock: 0,
        minimumGrade: ''
      });
      console.log('Added new item to new shop:', this.newShop.items);
    },
    removeNewItem(index) {
      this.newShop.items.splice(index, 1);
      console.log('Removed item from new shop:', index, this.newShop.items);
    },
    addNewShop() {
      if (!Array.isArray(this.job.shops)) {
        this.job.shops = [];
      }
      this.job.shops.push({ ...this.newShop });
      console.log('Added new shop:', this.newShop);
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
      console.log('Removed shop:', index, this.job.shops);
      this.$emit('update-job', this.job);
    }
  }
};


</script>
