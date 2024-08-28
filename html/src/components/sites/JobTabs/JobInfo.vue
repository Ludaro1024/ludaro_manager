<template>
  <div>
    <div>
      <label class="block mb-2">{{ $t('jobName') }}</label>
      <input type="text" v-model="job.name" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
    </div>
    <div>
      <label class="block mb-2">{{ $t('jobLabel') }}</label>
      <input type="text" v-model="job.label" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
    </div>
    <div>
  <label class="block mb-2 flex items-center">
    {{ $t('whitelisted') }}
    <input type="checkbox" v-model="job.whitelisted" class="ml-2">
  </label>
</div>
<div>
  <label class="block mb-2 flex items-center">
    {{ $t('societyPaid') }}
    <input type="checkbox" v-model="job.societypaid" class="ml-2">
  </label>
</div>

  </div>
</template>

  
  <script>
  export default {
    props: ['job']
  };
  </script>
  