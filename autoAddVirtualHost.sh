#!/usr/bin/env bash
#########################################################
#
# Script auto add Virtual host
# Author:GRS gaevoyrs@gmail.com
#
#########################################################

##############
# var
##############
PATH=$1
PATH_WWW="$1/www"
PATH_TEMPLATE="$PATH/template.template"
PATH_APACHE="/etc/apache2/sites-available"
PATH_HOSTS="/etc/hosts"
NEED_RESTART=0

##########
# method
##########

# add virtual host item
addVHItem() {
    ITEM=$1
    ITEM_APACHE="$PATH_APACHE/$ITEM"
    touch ${ITEM_APACHE}
    cat ${PATH_TEMPLATE} | sed "s/ITEM_APACHE/$ITEM_APACHE/g" > ${ITEM_APACHE}
    chmod 777 ${ITEM_APACHE}
    a2ensite ${ITEM_APACHE}
    echo "127.0.0.1       $ITEM" >> ${PATH_HOSTS}
    NEED_RESTART=1
}

# is set virtual host item in apache
isSetAddVHItem() {
    if [ -e "$PATH_APACHE/$1" ]
	then
	    #Файл уже есть
	    return 1
    fi
    #Файла нет
    return 0
}

# add virtual host
addVH() {
    for ITEM in `ls ${PATH_WWW}` ; do
        if [ `isSetAddVHItem ${ITEM}` -eq 0 ]
        then
            addVHItem ${ITEM}
        fi
    done

}

# dell virtual host item
dellVHItem() {
    ITEM=$1
    ITEM_APACHE="$PATH_APACHE/$ITEM"
    a2dissite ${ITEM_APACHE}
    rm -f ${ITEM_APACHE}
    NEED_RESTART=1
}

# is set virtual host item in www
isSetDellVHItem() {
    if [ -e "$PATH_WWW/$1" ]
	then
	    #Файл уже есть
	    return 1
    fi
    #Файла нет
    return 0
}

# dell virtual host
dellVH() {
    for ITEM in `ls ${PATH_APACHE}` ; do
        if [ `isSetDellVHItem ${ITEM}` -eq 0 ]
        then
            dellVHItem ${ITEM}
        fi
    done

}

# restart apache2
restart() {
    if [ ${NEED_RESTART} -eq 0 ]
    then
        service apache2 restart
    fi
}

#############
# test
#############

echo "Creating Virtual Host"
echo ${PATH}
echo ${PATH_WWW}
echo ${PATH_TEMPLATE}
echo ${PATH_APACHE}
echo ${NEED_RESTART}


#############
# script
#############

addVH
dellVH
restart
exit 0
