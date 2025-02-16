PGDMP      0                |            GENSHIN    16.0    16rc1 b    +           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ,           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            -           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            .           1262    16778    GENSHIN    DATABASE     }   CREATE DATABASE "GENSHIN" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "GENSHIN";
                postgres    false            �            1255    26149    can_assign_role(text, text) 	   PROCEDURE     G  CREATE PROCEDURE public.can_assign_role(IN first_user text, IN second_user text)
    LANGUAGE plpgsql
    AS $$
DECLARE
  rec record;
  num int := 1;
BEGIN
  IF NOT EXISTS(
    SELECT *
    FROM pg_user
    WHERE usename = first_user
  ) 
    THEN RAISE INFO 'Пользователь % не найден', first_user;
    RETURN;
  END IF;
  IF NOT EXISTS(
    SELECT *
    FROM pg_user
    WHERE usename = second_user
  ) 
    THEN RAISE INFO 'Пользователь % не найден', second_user;
    RETURN;
  END IF;
  RAISE INFO 'Текущий пользователь: %', first_user;
  RAISE INFO 'Кому выдаём права доступа: %', second_user;
  RAISE INFO 'No. Имя таблицы';
  RAISE INFO '--- -------------------------------';
  FOR rec IN
  with instead_of_IS as (SELECT u_grantor.rolname AS grantor,
    grantee.rolname AS grantee,
    current_database() AS table_catalog,
    nc.nspname AS table_schema,
    c.relname AS table_name,
    c.prtype AS privilege_type,
    CASE WHEN (pg_has_role(grantee.oid, c.relowner, 'USAGE'::text) OR c.grantable) 
	THEN 'YES'::text 
	ELSE 'NO'::text END AS is_grantable,
    CASE WHEN (c.prtype = 'SELECT'::text) 
	THEN 'YES'::text 
	ELSE 'NO'::text END AS with_hierarchy
   
   FROM ( SELECT pg_class.oid,
            pg_class.relname,
            pg_class.relnamespace,
            pg_class.relkind,
            pg_class.relowner,
            (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).grantor AS grantor,
            (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).grantee AS grantee,
            (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).privilege_type AS privilege_type,
            (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).is_grantable AS is_grantable
           FROM pg_class) 
		   as
		   c(oid, 
			 relname, 
			 relnamespace, 
			 relkind, 
			 relowner, 
			 grantor, 
			 grantee, 
			 prtype, 
			 grantable),

    pg_namespace as nc,
    pg_authid as u_grantor,
	
    ( SELECT pg_authid.oid, 
	 pg_authid.rolname
     FROM pg_authid 
	 UNION ALL
	 SELECT (0)::oid AS oid, 'PUBLIC'::name) 
	 
	 as grantee(oid, rolname)
	  
WHERE ((c.relnamespace = nc.oid) 
	   AND (c.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'f'::"char", 'p'::"char"])) 
	   AND (c.grantee = grantee.oid) 
	   AND (c.grantor = u_grantor.oid) 
	   AND (c.prtype = ANY (ARRAY['INSERT'::text, 'SELECT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text, 'REFERENCES'::text, 'TRIGGER'::text])) 
	   AND (pg_has_role(u_grantor.oid, 'USAGE'::text) 
			OR pg_has_role(grantee.oid, 'USAGE'::text) 
			OR (grantee.rolname = 'PUBLIC'::name)))
)
    SELECT DISTINCT table_name as name_of_table
    FROM instead_of_IS as grants
    JOIN pg_tables as tables
      ON grants.table_schema = tables.schemaname 
      AND grants.table_name = tables.tablename
    WHERE grantor = first_user
    AND is_grantable = 'YES'
    LOOP
      RAISE INFO '% %', num, rec.name_of_table;
      num := num + 1;
    END LOOP;
END
$$;
 P   DROP PROCEDURE public.can_assign_role(IN first_user text, IN second_user text);
       public          postgres    false            �            1259    17219 	   artifacts    TABLE     �   CREATE TABLE public.artifacts (
    id integer NOT NULL,
    name text NOT NULL,
    art_type text NOT NULL,
    art_rarity integer NOT NULL
);
    DROP TABLE public.artifacts;
       public         heap    postgres    false            �            1259    17218    artifacts_id_seq    SEQUENCE     �   CREATE SEQUENCE public.artifacts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.artifacts_id_seq;
       public          postgres    false    226            /           0    0    artifacts_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.artifacts_id_seq OWNED BY public.artifacts.id;
          public          postgres    false    225            �            1259    17344 	   ascension    TABLE     j   CREATE TABLE public.ascension (
    id integer NOT NULL,
    character_id integer,
    item_id integer
);
    DROP TABLE public.ascension;
       public         heap    postgres    false            �            1259    17343    ascension_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ascension_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.ascension_id_seq;
       public          postgres    false    229            0           0    0    ascension_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.ascension_id_seq OWNED BY public.ascension.id;
          public          postgres    false    228            �            1259    17173    ch_characteristics    TABLE       CREATE TABLE public.ch_characteristics (
    id integer,
    ch_rank integer NOT NULL,
    experience integer NOT NULL,
    target integer NOT NULL,
    hp integer NOT NULL,
    max_hp integer NOT NULL,
    atk integer NOT NULL,
    energy integer NOT NULL,
    status text NOT NULL
);
 &   DROP TABLE public.ch_characteristics;
       public         heap    postgres    false            �            1259    17164 
   characters    TABLE     �   CREATE TABLE public.characters (
    id integer NOT NULL,
    name text NOT NULL,
    ch_element text NOT NULL,
    rarity integer NOT NULL,
    weapon_type text NOT NULL,
    constellation text NOT NULL,
    birthday text NOT NULL
);
    DROP TABLE public.characters;
       public         heap    postgres    false            �            1259    17163    characters_id_seq    SEQUENCE     �   CREATE SEQUENCE public.characters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.characters_id_seq;
       public          postgres    false    216            1           0    0    characters_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.characters_id_seq OWNED BY public.characters.id;
          public          postgres    false    215            �            1259    17192    en_characteristics    TABLE     �   CREATE TABLE public.en_characteristics (
    id integer,
    experience integer NOT NULL,
    hp integer NOT NULL,
    max_hp integer NOT NULL,
    atk integer NOT NULL
);
 &   DROP TABLE public.en_characteristics;
       public         heap    postgres    false            �            1259    17184    enemies    TABLE     �   CREATE TABLE public.enemies (
    id integer NOT NULL,
    name text NOT NULL,
    en_class text NOT NULL,
    en_element text NOT NULL
);
    DROP TABLE public.enemies;
       public         heap    postgres    false            �            1259    17183    enemies_id_seq    SEQUENCE     �   CREATE SEQUENCE public.enemies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.enemies_id_seq;
       public          postgres    false    219            2           0    0    enemies_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.enemies_id_seq OWNED BY public.enemies.id;
          public          postgres    false    218            �            1259    17305 	   equipment    TABLE     �   CREATE TABLE public.equipment (
    character_id integer,
    weapon_id integer,
    flower_id integer,
    plume_id integer,
    sands_id integer,
    goblet_id integer,
    circlet_id integer
);
    DROP TABLE public.equipment;
       public         heap    postgres    false            �            1259    17396    fight_recordings    TABLE     �   CREATE TABLE public.fight_recordings (
    id bigint NOT NULL,
    fight_id bigint,
    character_hp integer NOT NULL,
    character_dmg integer NOT NULL,
    enemie_hp integer NOT NULL,
    enemie_dmg integer NOT NULL
);
 $   DROP TABLE public.fight_recordings;
       public         heap    postgres    false            �            1259    17395    fight_recordings_id_seq    SEQUENCE     �   CREATE SEQUENCE public.fight_recordings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.fight_recordings_id_seq;
       public          postgres    false    235            3           0    0    fight_recordings_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.fight_recordings_id_seq OWNED BY public.fight_recordings.id;
          public          postgres    false    234            �            1259    17378    fights    TABLE     �   CREATE TABLE public.fights (
    id bigint NOT NULL,
    character_id integer,
    enemie_id integer,
    fight_time timestamp with time zone NOT NULL
);
    DROP TABLE public.fights;
       public         heap    postgres    false            �            1259    17377    fights_id_seq    SEQUENCE     v   CREATE SEQUENCE public.fights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.fights_id_seq;
       public          postgres    false    233            4           0    0    fights_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.fights_id_seq OWNED BY public.fights.id;
          public          postgres    false    232            �            1259    17408 	   inventory    TABLE     S   CREATE TABLE public.inventory (
    id bigint NOT NULL,
    material_id integer
);
    DROP TABLE public.inventory;
       public         heap    postgres    false            �            1259    17407    inventory_id_seq    SEQUENCE     y   CREATE SEQUENCE public.inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.inventory_id_seq;
       public          postgres    false    237            5           0    0    inventory_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.inventory_id_seq OWNED BY public.inventory.id;
          public          postgres    false    236            �            1259    17361    loot    TABLE     b   CREATE TABLE public.loot (
    id integer NOT NULL,
    enemie_id integer,
    item_id integer
);
    DROP TABLE public.loot;
       public         heap    postgres    false            �            1259    17360    loot_id_seq    SEQUENCE     �   CREATE SEQUENCE public.loot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.loot_id_seq;
       public          postgres    false    231            6           0    0    loot_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.loot_id_seq OWNED BY public.loot.id;
          public          postgres    false    230            �            1259    17201 	   materials    TABLE     J   CREATE TABLE public.materials (
    id integer NOT NULL,
    name text
);
    DROP TABLE public.materials;
       public         heap    postgres    false            �            1259    17200    materials_id_seq    SEQUENCE     �   CREATE SEQUENCE public.materials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.materials_id_seq;
       public          postgres    false    222            7           0    0    materials_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.materials_id_seq OWNED BY public.materials.id;
          public          postgres    false    221            �            1259    17210    weapons    TABLE     �   CREATE TABLE public.weapons (
    id integer NOT NULL,
    name text NOT NULL,
    weap_type text NOT NULL,
    weap_rarity integer NOT NULL
);
    DROP TABLE public.weapons;
       public         heap    postgres    false            �            1259    17209    weapons_id_seq    SEQUENCE     �   CREATE SEQUENCE public.weapons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.weapons_id_seq;
       public          postgres    false    224            8           0    0    weapons_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.weapons_id_seq OWNED BY public.weapons.id;
          public          postgres    false    223            X           2604    17222    artifacts id    DEFAULT     l   ALTER TABLE ONLY public.artifacts ALTER COLUMN id SET DEFAULT nextval('public.artifacts_id_seq'::regclass);
 ;   ALTER TABLE public.artifacts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    226    226            Y           2604    17347    ascension id    DEFAULT     l   ALTER TABLE ONLY public.ascension ALTER COLUMN id SET DEFAULT nextval('public.ascension_id_seq'::regclass);
 ;   ALTER TABLE public.ascension ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228    229            T           2604    17167    characters id    DEFAULT     n   ALTER TABLE ONLY public.characters ALTER COLUMN id SET DEFAULT nextval('public.characters_id_seq'::regclass);
 <   ALTER TABLE public.characters ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    216    216            U           2604    17187 
   enemies id    DEFAULT     h   ALTER TABLE ONLY public.enemies ALTER COLUMN id SET DEFAULT nextval('public.enemies_id_seq'::regclass);
 9   ALTER TABLE public.enemies ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    219    219            \           2604    17399    fight_recordings id    DEFAULT     z   ALTER TABLE ONLY public.fight_recordings ALTER COLUMN id SET DEFAULT nextval('public.fight_recordings_id_seq'::regclass);
 B   ALTER TABLE public.fight_recordings ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    235    235            [           2604    17381 	   fights id    DEFAULT     f   ALTER TABLE ONLY public.fights ALTER COLUMN id SET DEFAULT nextval('public.fights_id_seq'::regclass);
 8   ALTER TABLE public.fights ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232    233            ]           2604    17411    inventory id    DEFAULT     l   ALTER TABLE ONLY public.inventory ALTER COLUMN id SET DEFAULT nextval('public.inventory_id_seq'::regclass);
 ;   ALTER TABLE public.inventory ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    236    237            Z           2604    17364    loot id    DEFAULT     b   ALTER TABLE ONLY public.loot ALTER COLUMN id SET DEFAULT nextval('public.loot_id_seq'::regclass);
 6   ALTER TABLE public.loot ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    231    230    231            V           2604    17204    materials id    DEFAULT     l   ALTER TABLE ONLY public.materials ALTER COLUMN id SET DEFAULT nextval('public.materials_id_seq'::regclass);
 ;   ALTER TABLE public.materials ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    222    222            W           2604    17213 
   weapons id    DEFAULT     h   ALTER TABLE ONLY public.weapons ALTER COLUMN id SET DEFAULT nextval('public.weapons_id_seq'::regclass);
 9   ALTER TABLE public.weapons ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    224    224                      0    17219 	   artifacts 
   TABLE DATA           C   COPY public.artifacts (id, name, art_type, art_rarity) FROM stdin;
    public          postgres    false    226   �}                  0    17344 	   ascension 
   TABLE DATA           >   COPY public.ascension (id, character_id, item_id) FROM stdin;
    public          postgres    false    229   ؀                 0    17173    ch_characteristics 
   TABLE DATA           n   COPY public.ch_characteristics (id, ch_rank, experience, target, hp, max_hp, atk, energy, status) FROM stdin;
    public          postgres    false    217   ��                 0    17164 
   characters 
   TABLE DATA           h   COPY public.characters (id, name, ch_element, rarity, weapon_type, constellation, birthday) FROM stdin;
    public          postgres    false    216   V�                 0    17192    en_characteristics 
   TABLE DATA           M   COPY public.en_characteristics (id, experience, hp, max_hp, atk) FROM stdin;
    public          postgres    false    220   ��                 0    17184    enemies 
   TABLE DATA           A   COPY public.enemies (id, name, en_class, en_element) FROM stdin;
    public          postgres    false    219   ��                 0    17305 	   equipment 
   TABLE DATA           r   COPY public.equipment (character_id, weapon_id, flower_id, plume_id, sands_id, goblet_id, circlet_id) FROM stdin;
    public          postgres    false    227   ��       &          0    17396    fight_recordings 
   TABLE DATA           l   COPY public.fight_recordings (id, fight_id, character_hp, character_dmg, enemie_hp, enemie_dmg) FROM stdin;
    public          postgres    false    235   Ȋ       $          0    17378    fights 
   TABLE DATA           I   COPY public.fights (id, character_id, enemie_id, fight_time) FROM stdin;
    public          postgres    false    233   �       (          0    17408 	   inventory 
   TABLE DATA           4   COPY public.inventory (id, material_id) FROM stdin;
    public          postgres    false    237   �       "          0    17361    loot 
   TABLE DATA           6   COPY public.loot (id, enemie_id, item_id) FROM stdin;
    public          postgres    false    231   �                 0    17201 	   materials 
   TABLE DATA           -   COPY public.materials (id, name) FROM stdin;
    public          postgres    false    222   <�                 0    17210    weapons 
   TABLE DATA           C   COPY public.weapons (id, name, weap_type, weap_rarity) FROM stdin;
    public          postgres    false    224   Y�       9           0    0    artifacts_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.artifacts_id_seq', 124, true);
          public          postgres    false    225            :           0    0    ascension_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.ascension_id_seq', 1, false);
          public          postgres    false    228            ;           0    0    characters_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.characters_id_seq', 45, true);
          public          postgres    false    215            <           0    0    enemies_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.enemies_id_seq', 45, true);
          public          postgres    false    218            =           0    0    fight_recordings_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.fight_recordings_id_seq', 1, false);
          public          postgres    false    234            >           0    0    fights_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.fights_id_seq', 1, false);
          public          postgres    false    232            ?           0    0    inventory_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.inventory_id_seq', 1, false);
          public          postgres    false    236            @           0    0    loot_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.loot_id_seq', 1, false);
          public          postgres    false    230            A           0    0    materials_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.materials_id_seq', 1, false);
          public          postgres    false    221            B           0    0    weapons_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.weapons_id_seq', 60, true);
          public          postgres    false    223            g           2606    17226    artifacts artifacts_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT artifacts_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.artifacts DROP CONSTRAINT artifacts_pkey;
       public            postgres    false    226            i           2606    17349    ascension ascension_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.ascension
    ADD CONSTRAINT ascension_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.ascension DROP CONSTRAINT ascension_pkey;
       public            postgres    false    229            _           2606    17171    characters characters_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.characters DROP CONSTRAINT characters_pkey;
       public            postgres    false    216            a           2606    17191    enemies enemies_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.enemies
    ADD CONSTRAINT enemies_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.enemies DROP CONSTRAINT enemies_pkey;
       public            postgres    false    219            o           2606    17401 &   fight_recordings fight_recordings_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.fight_recordings
    ADD CONSTRAINT fight_recordings_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.fight_recordings DROP CONSTRAINT fight_recordings_pkey;
       public            postgres    false    235            m           2606    17383    fights fights_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.fights
    ADD CONSTRAINT fights_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.fights DROP CONSTRAINT fights_pkey;
       public            postgres    false    233            q           2606    17413    inventory inventory_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.inventory DROP CONSTRAINT inventory_pkey;
       public            postgres    false    237            k           2606    17366    loot loot_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.loot
    ADD CONSTRAINT loot_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.loot DROP CONSTRAINT loot_pkey;
       public            postgres    false    231            c           2606    17208    materials materials_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.materials DROP CONSTRAINT materials_pkey;
       public            postgres    false    222            e           2606    17217    weapons weapons_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.weapons
    ADD CONSTRAINT weapons_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.weapons DROP CONSTRAINT weapons_pkey;
       public            postgres    false    224            {           2606    17350 %   ascension ascension_character_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ascension
    ADD CONSTRAINT ascension_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.ascension DROP CONSTRAINT ascension_character_id_fkey;
       public          postgres    false    4703    229    216            |           2606    17355     ascension ascension_item_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ascension
    ADD CONSTRAINT ascension_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.materials(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.ascension DROP CONSTRAINT ascension_item_id_fkey;
       public          postgres    false    222    229    4707            r           2606    17178 -   ch_characteristics ch_characteristics_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ch_characteristics
    ADD CONSTRAINT ch_characteristics_id_fkey FOREIGN KEY (id) REFERENCES public.characters(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.ch_characteristics DROP CONSTRAINT ch_characteristics_id_fkey;
       public          postgres    false    4703    216    217            s           2606    17195 -   en_characteristics en_characteristics_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.en_characteristics
    ADD CONSTRAINT en_characteristics_id_fkey FOREIGN KEY (id) REFERENCES public.enemies(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.en_characteristics DROP CONSTRAINT en_characteristics_id_fkey;
       public          postgres    false    4705    220    219            t           2606    17308 %   equipment equipment_character_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.equipment DROP CONSTRAINT equipment_character_id_fkey;
       public          postgres    false    4703    227    216            u           2606    17338 #   equipment equipment_circlet_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_circlet_id_fkey FOREIGN KEY (circlet_id) REFERENCES public.artifacts(id) ON UPDATE CASCADE ON DELETE SET NULL;
 M   ALTER TABLE ONLY public.equipment DROP CONSTRAINT equipment_circlet_id_fkey;
       public          postgres    false    226    227    4711            v           2606    17318 "   equipment equipment_flower_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_flower_id_fkey FOREIGN KEY (flower_id) REFERENCES public.artifacts(id) ON UPDATE CASCADE ON DELETE SET NULL;
 L   ALTER TABLE ONLY public.equipment DROP CONSTRAINT equipment_flower_id_fkey;
       public          postgres    false    226    227    4711            w           2606    17333 "   equipment equipment_goblet_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_goblet_id_fkey FOREIGN KEY (goblet_id) REFERENCES public.artifacts(id) ON UPDATE CASCADE ON DELETE SET NULL;
 L   ALTER TABLE ONLY public.equipment DROP CONSTRAINT equipment_goblet_id_fkey;
       public          postgres    false    227    226    4711            x           2606    17323 !   equipment equipment_plume_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_plume_id_fkey FOREIGN KEY (plume_id) REFERENCES public.artifacts(id) ON UPDATE CASCADE ON DELETE SET NULL;
 K   ALTER TABLE ONLY public.equipment DROP CONSTRAINT equipment_plume_id_fkey;
       public          postgres    false    227    226    4711            y           2606    17328 !   equipment equipment_sands_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_sands_id_fkey FOREIGN KEY (sands_id) REFERENCES public.artifacts(id) ON UPDATE CASCADE ON DELETE SET NULL;
 K   ALTER TABLE ONLY public.equipment DROP CONSTRAINT equipment_sands_id_fkey;
       public          postgres    false    226    4711    227            z           2606    17313 "   equipment equipment_weapon_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_weapon_id_fkey FOREIGN KEY (weapon_id) REFERENCES public.weapons(id) ON UPDATE CASCADE ON DELETE SET NULL;
 L   ALTER TABLE ONLY public.equipment DROP CONSTRAINT equipment_weapon_id_fkey;
       public          postgres    false    4709    224    227            �           2606    17402 /   fight_recordings fight_recordings_fight_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.fight_recordings
    ADD CONSTRAINT fight_recordings_fight_id_fkey FOREIGN KEY (fight_id) REFERENCES public.fights(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.fight_recordings DROP CONSTRAINT fight_recordings_fight_id_fkey;
       public          postgres    false    235    4717    233                       2606    17384    fights fights_character_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.fights
    ADD CONSTRAINT fights_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.fights DROP CONSTRAINT fights_character_id_fkey;
       public          postgres    false    4703    216    233            �           2606    17389    fights fights_enemie_id_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.fights
    ADD CONSTRAINT fights_enemie_id_fkey FOREIGN KEY (enemie_id) REFERENCES public.enemies(id);
 F   ALTER TABLE ONLY public.fights DROP CONSTRAINT fights_enemie_id_fkey;
       public          postgres    false    233    4705    219            �           2606    17414 $   inventory inventory_material_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.materials(id);
 N   ALTER TABLE ONLY public.inventory DROP CONSTRAINT inventory_material_id_fkey;
       public          postgres    false    4707    237    222            }           2606    17367    loot loot_enemie_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.loot
    ADD CONSTRAINT loot_enemie_id_fkey FOREIGN KEY (enemie_id) REFERENCES public.enemies(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.loot DROP CONSTRAINT loot_enemie_id_fkey;
       public          postgres    false    4705    219    231            ~           2606    17372    loot loot_item_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.loot
    ADD CONSTRAINT loot_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.materials(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.loot DROP CONSTRAINT loot_item_id_fkey;
       public          postgres    false    231    222    4707               �  x���˒� E��+���)�[��Ma�2Py��i&��GL	6r���=}��f$�>AUWe|>���R�*Hwj���ڴ ��8<+���ϸ�7��f�Q&��"F��N��M��p�|�a����� ��(��[o�*t�T������������Q��g8�
f��mK�pB[#q���W4���+n��ߑ�d�M$)�	�MrG�yH#�> ��Up�[g�8c&Δ������tu>N�`�p����(��{��%3���
�@_��d�����,;��l��pg&����ߴL��9$SIOI��X�:���ɤ�̤?Τ/ͤ�ͤ	�#��*�]�����̌�e��Ѷp{����t�a�	F�B�x�͂m��5�oQ���2?4���
�n:vç�0��-^7�������ձܚE��4�a �EX�W�q$!�L��b�c����yY�X�lj���4�/J�̈�L�t/:�<��1�F2/�n��n>	5�A��qʁjO=�BUYD8�΅BmfR�i�J
uI��,)���j���2�b4+*FK�b� ,F��b43.F��b�40Fct$�洺
R�����yW���M�1|����>��J�c5�7��M�BH�ƚ����x/�m�ޏ��r�^Խ.�{�Q���o�WP\�Ϳ#�q��/�0���p߉�P:������ �             x������ � �         Q  x�m�A�1D�=��\��}���"�HY������R���H�4
P��R*����}��|�wu��Et��N�鵿i�я���Ƭ/��1�'�b�e��������m����e��c�y�+����㵹/ r�x5��n_FZ����V�n�p٠<Q����,&�T��!S\�f���3��t�����tg��ׅ~�	���vf��O@�Kk8C�S�B'PRi����2b8<D�����u<]�RJ��v�9��~��>�;��b�#%>g��s+U�Z�h�W�^Ƌ[		� �.�t6d���z��)#�@K��?t�����t�^�48VR�nB��w��� r\(��X��mUp͕�hs�~�9T/�+Y^D-���?)5K�%��xz���څu�J���MѼVc8ҙ[��4�=4���r��*Qn�3�B�w�(爽i��*}, 9]l���2P_��kaY��Y��L�Rh�{X�G��	�lQ��Du�dZg+M��g��\�4ܭ<xx��O�W19�bp�O�^�2���s�p/X;j���bYe���"샲�r�u>�1���W������J�Kl         7  x�mV�n�6|^���$�Is9m�;�M�6E_V��ڄ"�����]J��\��6��������.��p$;�YWC��T���r䱢�CO���$���7�n��ga���:9��z��9T��C�/�~�>1T��:���^��*�Z�����z���'t%:�f���+�F��J.����|"�m �T��l"8q�S-���.�T��^PƐ����mg=�
5��?c�k�\�-�Z�X��&t-�xd/Ⱦ
>���
Wo��A���$e��hj6�N�F*��$ڵ��9�,�Ԑ	%�L�z�V�Tv�Vkb����xd=
]�;�c:VxA|fk0E�A��Q������ٺ�g�Һԣt��墚���<�1+�]xCh�](��4+n;M�9y&��g[���+����;͕�c�;�sԲ�L�m�[��(�c��p�4,��fǓU�"�����(�b.p��,�B҉=k�	'/F�dWpO�l�K�i��Z���%�e|晚��{��g�	�.օ�<��ԛ��ó�1"��t�X�Nک���y&�e	6�\�J��ˠѳU5��|N�Q�<����T^<�
�<p��iq��A�A��ʴ�#`C\DZ2���K\�a�}_�e�&�`��r���,^��/��Ӿ�ε`/ŉPv9_D���Պx4&��Y�2=���]�L�ίૌ�Pf>c���"��\�ֵ�����k��_yjc�����`���'Iq⛬�OP��#{�.���Lݾؖ?�_K�"	Qo[ኞ\�e.rx�!,C9G�PI�R�X���b���ǆLC��4�*����ںE���
DFj,�+�]�.�Oq�g�ɜ���C�lO!(~��s޴(|���I���>J
m��ncK��c��E�!5�.Mn_GG>�
�a�y��+@T�ZΛ�+��}�7�r���ݳx3�k�^D� �:3,s:��M4�2�(�6�'4y($5R��O@bR�/����悱�s<�Vlߢ�MH#)
x"-E%��`��tXr�j+9�yc�m�����ͼF��9TG'//��?�A�����<��H�5vBP���L�j���f��*r��         �   x�u�[��0E�e1.�B�2�_���&���M�1�@qb�vV3�I5{�Y�-���[�UJVR/i+i�4K�K
~�mb�Xj�5�{�Ǭ�ӝqEw4BL!�ȸCR��ӄr��v�����qh���9��s#��V��k�����k��ֹ����;�`d�t�`�~�����|+�V���[��|4�v4XIc)0�p'ͥ�\;�Tk��y�񾃌k�K��Y�XM�b_�l���qGkfd�տ�����!�?�[��         �  x�}�]�� ��a�`N �yA�(�Q2��8�4I�r�Tݯ
)j��U;�*�u�G�����B���_��j����Uf��iV���ʙ|ɀ/�9��U|}/��E-���2eΥ�����J�=t�Xщ�p�)����e���6=�c�צ��UZ�2�?���)[ czI�����/��W�0�:a:�Ę��J%�ɾ!�/�N��'���QkˏP��G����R���WT_�ӍKtF�Jv�G�XĲUf$l�t��w�P����
t+F�,m�N
�YZѝ�1��� �b�6ݎ=�/�������&�BKmmr�S���3�����yג��K���Hp�H|�E&�H)o
t�9=�'p��ڡ���N���褧��pE��3H�KJ�tҺ�����z(m�#��
N����|okX���#B(h�p�C����5/��qm�`�����n�ía'��g���,�6���5�|qu~����r!P            x������ � �      &      x������ � �      $      x������ � �      (      x������ � �      "      x������ � �            x������ � �         �  x���˲� �u��f7%^�e6�b��� ���?�INb���R�����w�4�q6�z��- �&�I�86�C��-D	���^[��>ð��F��,���1�v�;*Jp��<��+DRl��퀺�)A{g���<�T��?g��{�Q�m�`rF���2�<^����[�A ��u���7��o͞f��ưM�q�3����xm��_����޻��=JV��ڨ.�[�cd��6�`z����dªMv��n����7Lڪ4Lt�Ɯg�����{��;`G�?��INy\o^wʿ%EN3ګ�����i:�$�I.���I�?ө�7,�%,"ͺx��^~�F�p�<�[E/g]T���@	�li������ZA�.�����j�{��D}`��'#gGF��9?6rqb�r�ȋ3#/���Gc}dٞQ�c��O����83
y`�'�(�ծ�>6���(ٞQ�gF��R|2Jyd�ŞQ�'���X������w�$_�*     