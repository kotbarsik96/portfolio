<script setup>
import avatar from '../../images/about/avatar.png'
import { inject } from 'vue'

const worksCount = inject('worksCount')
const skillsCount = inject('skillsCount')
const stack = inject('stack').join(', ')
</script>

<template>
    <section id="about">
        <div class="container">
            <h2 class="section-title">
                <span>О себе и о сайте</span>
            </h2>
            <div class="about">
                <div class="about__images">
                    <div class="about__image-container">
                        <ImagePicture :path="avatar" alt="Изображение" class="about__image"></ImagePicture>
                    </div>
                </div>
                <div class="about__text">
                    <ul class="list">
                        <li class="list__item icon-person">
                            <span class="list__item-title">
                                Имя:
                            </span>
                            <span class="list__item-content">Лёша</span>
                        </li>
                        <li class="list__item icon-activity">
                            <span class="list__item-title">
                                Деятельность:
                            </span>
                            <span class="list__item-content">
                                Frontend и backend разработка
                            </span>
                        </li>
                        <li class="list__item icon-programming">
                            <span class="list__item-title">
                                Стек:
                            </span>
                            <span class="list__item-content">
                                {{ stack }}
                            </span>
                        </li>
                        <li class="list__item icon-portfolio">
                            <a class="link list__item-title" href="#portfolio">
                                Работ в портфолио:
                            </a>
                            <span class="list__item-content">{{ worksCount }}</span>
                        </li>
                        <li class="list__item icon-web-development">
                            <a class="link list__item-title" href="#skills">
                                Навыков в портфолио:
                            </a>
                            <span class="list__item-content">
                                {{ skillsCount }}
                            </span>
                        </li>
                    </ul>
                    <p class="about__text-par">
                        На этом сайте я собрал свои работы, которые могу опубликовать. Так я чётко могу увидеть свой
                        прогресс и продемонстрировать его тем, кто заинтересован в работе со мной
                    </p>
                    <br>
                    <p class="about__text-par">
                        Я работаю и с чистым JS, и с фреймворком Vue JS
                    </p>
                    <br>
                    <p class="about__text-par" queue>
                        Тут я собрал достаточно навыков, которые могу продемонстрировать в
                        <a class="link" href="#skills">
                            своём списке
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </section>
</template>