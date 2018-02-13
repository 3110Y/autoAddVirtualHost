#!/bin/bash
#########################################################
#
# Script auto add Virtual host
# Author:GRS gaevoyrs@gmail.com
#
#########################################################

##############
# var
##############
PATH_INIT=$1
PATH_WWW="$1/www"
PATH_TEMPLATE="$PATH_INIT/template.template"
PATH_APACHE="/etc/apache2/sites-available"
PATH_HOSTS="/etc/hosts"
NEED_RESTART=0

##########
# method
##########

# add virtual host item
addVHItem() {
    ITEM=$1
    ITEM_APACHE="$PATH_APACHE/$ITEM.conf"
    chmod 777 "$PATH_WWW/$ITEM"
    echo "Копирование из $PATH_TEMPLATE в $ITEM_APACHE"
    cp ${PATH_TEMPLATE} ${ITEM_APACHE}
    sed -i -e "s/ITEM_APACHE/$ITEM/g" ${ITEM_APACHE}
    chmod 777 ${ITEM_APACHE}
    a2ensite "$ITEM.conf"
    echo "127.0.0.1       $ITEM" >> ${PATH_HOSTS}
    NEED_RESTART=1
}

# add virtual host
addVH() {
    cd ${PATH_WWW}
    for ITEM in `ls ${PATH_WWW}` ; do
        if [ ! -e "$PATH_APACHE/$ITEM.conf" ]
        then
            addVHItem ${ITEM}
            echo ${ITEM}
        fi
    done

}

# dell virtual host item
dellVHItem() {
    ITEM=$1
    ITEM_APACHE="$PATH_APACHE/$ITEM.conf"
    a2dissite "$ITEM.conf"
    rm -f ${ITEM_APACHE}
    NEED_RESTART=1
}

# dell virtual host
dellVH() {
    for ITEM in `ls ${PATH_APACHE}` ; do
        ITEM=`echo ${ITEM} | rev | cut -c 6- | rev`
        if [ ! -e "$PATH_WWW/$ITEM"  ]
        then
           dellVHItem ${ITEM}
        fi
    done

}

# restart apache2
restart() {
    if [ ${NEED_RESTART} -eq 1 ]
    then
        systemctl reload apache2
    fi
}

#############
# test
#############

#echo "Creating Virtual Host"
#echo ${PATH}
#echo ${PATH_WWW}
#echo ${PATH_TEMPLATE}
#echo ${PATH_APACHE}
#echo ${NEED_RESTART}


#############
# script
#############

addVH
dellVH
restart
exit 0
