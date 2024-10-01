<template>
  <div class="under-construction">
    <div class="message">
      <span class="text">{{ $t('underConstruction') }}</span>
      <br>
      <span class="text">{{ $t('unavailable') }}</span>
    </div>
  </div>
</template>

<style>
    .under-construction {
      display: flex;
      justify-content: center;
      align-items: center;
    }
  
    .message {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 1rem;
      padding: 1rem;
      border-radius: 1rem;
      background-color: #d6d8f0;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
  
    .text {
      font-size: 1.5rem;
      font-weight: 500;
      color: #333;
    }
  </style>