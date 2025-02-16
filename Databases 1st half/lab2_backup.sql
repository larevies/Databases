PGDMP      1                |            LAB2    16.0    16rc1 &    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16396    LAB2    DATABASE     z   CREATE DATABASE "LAB2" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "LAB2";
                postgres    false            �            1259    16756    doors    TABLE     �  CREATE TABLE public.doors (
    door_id bigint NOT NULL,
    door_state text NOT NULL,
    surface text NOT NULL,
    handle_presence boolean NOT NULL,
    button_presence boolean NOT NULL,
    bell_presence boolean NOT NULL,
    CONSTRAINT sscheck CHECK ((((door_state = 'Открытая'::text) OR (door_state = 'Закрытая'::text)) AND ((surface = 'Гладкая'::text) OR (surface = 'Шероховатая'::text))))
);
    DROP TABLE public.doors;
       public         heap    postgres    false            �            1259    16755    doors_door_id_seq    SEQUENCE     z   CREATE SEQUENCE public.doors_door_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.doors_door_id_seq;
       public          postgres    false    222            �           0    0    doors_door_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.doors_door_id_seq OWNED BY public.doors.door_id;
          public          postgres    false    221            �            1259    16765    doors_in_rooms    TABLE     Q   CREATE TABLE public.doors_in_rooms (
    door_id integer,
    room_id integer
);
 "   DROP TABLE public.doors_in_rooms;
       public         heap    postgres    false            �            1259    16719 	   lightning    TABLE     g   CREATE TABLE public.lightning (
    lightning_id bigint NOT NULL,
    lightning_level text NOT NULL
);
    DROP TABLE public.lightning;
       public         heap    postgres    false            �            1259    16718    lightning_lightning_id_seq    SEQUENCE     �   CREATE SEQUENCE public.lightning_lightning_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.lightning_lightning_id_seq;
       public          postgres    false    216            �           0    0    lightning_lightning_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.lightning_lightning_id_seq OWNED BY public.lightning.lightning_id;
          public          postgres    false    215            �            1259    16742    people    TABLE     �   CREATE TABLE public.people (
    person_id bigint NOT NULL,
    room_id integer,
    person_name text NOT NULL,
    emotional_state text NOT NULL
);
    DROP TABLE public.people;
       public         heap    postgres    false            �            1259    16741    people_person_id_seq    SEQUENCE     }   CREATE SEQUENCE public.people_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.people_person_id_seq;
       public          postgres    false    220            �           0    0    people_person_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.people_person_id_seq OWNED BY public.people.person_id;
          public          postgres    false    219            �            1259    16728    rooms    TABLE     �   CREATE TABLE public.rooms (
    room_id bigint NOT NULL,
    lightning_id integer,
    room_name text NOT NULL,
    switch_presence boolean NOT NULL,
    lock_presence boolean NOT NULL
);
    DROP TABLE public.rooms;
       public         heap    postgres    false            �            1259    16727    rooms_room_id_seq    SEQUENCE     z   CREATE SEQUENCE public.rooms_room_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.rooms_room_id_seq;
       public          postgres    false    218            �           0    0    rooms_room_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.rooms_room_id_seq OWNED BY public.rooms.room_id;
          public          postgres    false    217            0           2604    16759    doors door_id    DEFAULT     n   ALTER TABLE ONLY public.doors ALTER COLUMN door_id SET DEFAULT nextval('public.doors_door_id_seq'::regclass);
 <   ALTER TABLE public.doors ALTER COLUMN door_id DROP DEFAULT;
       public          postgres    false    222    221    222            -           2604    16722    lightning lightning_id    DEFAULT     �   ALTER TABLE ONLY public.lightning ALTER COLUMN lightning_id SET DEFAULT nextval('public.lightning_lightning_id_seq'::regclass);
 E   ALTER TABLE public.lightning ALTER COLUMN lightning_id DROP DEFAULT;
       public          postgres    false    216    215    216            /           2604    16745    people person_id    DEFAULT     t   ALTER TABLE ONLY public.people ALTER COLUMN person_id SET DEFAULT nextval('public.people_person_id_seq'::regclass);
 ?   ALTER TABLE public.people ALTER COLUMN person_id DROP DEFAULT;
       public          postgres    false    220    219    220            .           2604    16731    rooms room_id    DEFAULT     n   ALTER TABLE ONLY public.rooms ALTER COLUMN room_id SET DEFAULT nextval('public.rooms_room_id_seq'::regclass);
 <   ALTER TABLE public.rooms ALTER COLUMN room_id DROP DEFAULT;
       public          postgres    false    217    218    218            �          0    16756    doors 
   TABLE DATA           n   COPY public.doors (door_id, door_state, surface, handle_presence, button_presence, bell_presence) FROM stdin;
    public          postgres    false    222   $+       �          0    16765    doors_in_rooms 
   TABLE DATA           :   COPY public.doors_in_rooms (door_id, room_id) FROM stdin;
    public          postgres    false    223   A+       �          0    16719 	   lightning 
   TABLE DATA           B   COPY public.lightning (lightning_id, lightning_level) FROM stdin;
    public          postgres    false    216   ^+       �          0    16742    people 
   TABLE DATA           R   COPY public.people (person_id, room_id, person_name, emotional_state) FROM stdin;
    public          postgres    false    220   {+       �          0    16728    rooms 
   TABLE DATA           a   COPY public.rooms (room_id, lightning_id, room_name, switch_presence, lock_presence) FROM stdin;
    public          postgres    false    218   �+       �           0    0    doors_door_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.doors_door_id_seq', 1, false);
          public          postgres    false    221            �           0    0    lightning_lightning_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.lightning_lightning_id_seq', 1, false);
          public          postgres    false    215            �           0    0    people_person_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.people_person_id_seq', 10, true);
          public          postgres    false    219            �           0    0    rooms_room_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.rooms_room_id_seq', 1, false);
          public          postgres    false    217            9           2606    16764    doors doors_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.doors
    ADD CONSTRAINT doors_pkey PRIMARY KEY (door_id);
 :   ALTER TABLE ONLY public.doors DROP CONSTRAINT doors_pkey;
       public            postgres    false    222            3           2606    16726    lightning lightning_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.lightning
    ADD CONSTRAINT lightning_pkey PRIMARY KEY (lightning_id);
 B   ALTER TABLE ONLY public.lightning DROP CONSTRAINT lightning_pkey;
       public            postgres    false    216            7           2606    16749    people people_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (person_id);
 <   ALTER TABLE ONLY public.people DROP CONSTRAINT people_pkey;
       public            postgres    false    220            5           2606    16735    rooms rooms_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_id);
 :   ALTER TABLE ONLY public.rooms DROP CONSTRAINT rooms_pkey;
       public            postgres    false    218            <           2606    16768 *   doors_in_rooms doors_in_rooms_door_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.doors_in_rooms
    ADD CONSTRAINT doors_in_rooms_door_id_fkey FOREIGN KEY (door_id) REFERENCES public.doors(door_id) ON DELETE SET NULL;
 T   ALTER TABLE ONLY public.doors_in_rooms DROP CONSTRAINT doors_in_rooms_door_id_fkey;
       public          postgres    false    222    223    4665            =           2606    16773 *   doors_in_rooms doors_in_rooms_room_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.doors_in_rooms
    ADD CONSTRAINT doors_in_rooms_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(room_id) ON DELETE SET NULL;
 T   ALTER TABLE ONLY public.doors_in_rooms DROP CONSTRAINT doors_in_rooms_room_id_fkey;
       public          postgres    false    223    4661    218            ;           2606    16750    people people_room_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(room_id) ON DELETE SET NULL;
 D   ALTER TABLE ONLY public.people DROP CONSTRAINT people_room_id_fkey;
       public          postgres    false    218    4661    220            :           2606    16736    rooms rooms_lightning_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_lightning_id_fkey FOREIGN KEY (lightning_id) REFERENCES public.lightning(lightning_id) ON DELETE SET NULL;
 G   ALTER TABLE ONLY public.rooms DROP CONSTRAINT rooms_lightning_id_fkey;
       public          postgres    false    218    216    4659            �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �     