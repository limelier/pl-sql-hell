-- run if table already exists
drop table minecraft_favorites cascade constraints;

create table minecraft_favorites
(
    id                   int not null primary key,
    id_student            not null,
    favorite_food        varchar2(255),
    favorite_enchantment varchar2(255),
    favorite_version     varchar2(255),
    constraint fk_minecraft_id_student foreign key (id_student) references studenti (id)
);

declare
    type varr is varray (1000) of varchar2(255);
    minecraft_food        varr := varr('Apple', 'Baked Potato', 'Beetroot', 'Beetrout Soup', 'Bread', 'Cake', 'Carrot',
                                       'Chorus Fruit', 'Cooked Chicken', 'Cooked Cod', 'Cooked Mutton',
                                       'Cooked Porkchop', 'Cooked Rabbit', 'Cooked Salmon', 'Cookie', 'Dried Kelp',
                                       'Enchanted Golden Apple', 'Golden Apple', 'Golden Carrot', 'Honey Bottle',
                                       'Melon Slice', 'Mushroom Stew', 'Poisonous Potato', 'Potato', 'Pufferfish',
                                       'Pumpkin Pie', 'Rabbit Stew', 'Raw Beef', 'Raw Chicken', 'Raw Cod', 'Raw Mutton',
                                       'Raw Porkchop', 'Raw Rabbit', 'Raw Salmon', 'Rotten Flesh', 'Spider Eye',
                                       'Steak', 'Suspicious Stew', 'Sweet Berries', 'Tropical Fish');
    minecraft_enchantment varr := varr('Aqua Affinity', 'Bane of Arthropods', 'Blast Protection', 'Channeling',
                                       'Chopping', 'Curse of Binding', 'Curse of Vanishing', 'Depth Strider',
                                       'Efficiency', 'Feather Falling', 'Fire Aspect', 'Fire Protection', 'Flame',
                                       'Frost Walker', 'Impaling', 'Infinity', 'Knockback', 'Looting', 'Loyalty',
                                       'Luck of the Sea', 'Lure', 'Mending', 'Multishot', 'Piercing', 'Power',
                                       'Projectile Protection', 'Protection', 'Punch', 'Quick Charge', 'Respiration',
                                       'Riptide', 'Sharpness', 'Silk Touch', 'Smite', 'Soul Speed', 'Sweeping Edge',
                                       'Thorns', 'Unbreaking');
    minecraft_version     varr := varr('Pre-classic', 'Classic', 'Indev', 'Infdev', 'Alpha 1.0', 'Alpha 1.1',
                                       'Alpha 1.2', 'Beta 1.0', 'Beta 1.1', 'Beta 1.2', 'Beta 1.3', 'Beta 1.4',
                                       'Beta 1.5', 'Beta 1.6', 'Beta 1.7', 'Beta 1.8', '1.0', '1.1', '1.2', '1.3',
                                       '1.4', '1.5', '1.6', '1.7', '1.8', '1.9', '1.10', '1.11', '1.12', '1.13', '1.14',
                                       '1.15');
    v_food                varchar2(255);
    v_enchantment         varchar2(255);
    v_version             varchar2(255);
    v_id                  int;
    cursor c_studs is select id
                      from studenti;
begin
    v_id := 1;
    for stud in c_studs
        loop
            v_food := minecraft_food(trunc(dbms_random.value(0, minecraft_food.count)) + 1);
            v_enchantment := minecraft_enchantment(trunc(dbms_random.value(0, minecraft_enchantment.count)) + 1);
            v_version := minecraft_version(trunc(dbms_random.value(0, minecraft_version.count)) + 1);

            insert into minecraft_favorites
            values (v_id,
                    stud.id,
                    v_food,
                    v_enchantment,
                    v_version
            );
            v_id := v_id + 1;
        end loop;
end;

select * from minecraft_favorites;