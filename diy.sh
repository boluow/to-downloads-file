#!/usr/bin/env bash

## 当前脚本清单：
## jd_super_redrain.js          整点红包雨
## jd_half_redrain.js           半点红包雨
## jx_cfdtx.js                  京喜财富岛提现
## jd_paopao.js                 泡泡大作战
## monk_inter_shop_sign.js      interCenter渠道店铺签到
## monk_shop_follow_sku.js      店铺关注有礼
## monk_shop_lottery.js         店铺大转盘
## adolf_pk.js                  京享值PK
## adolf_martin.js              人头马x博朗
## adolf_flp.js                 飞利浦电视成长记
## adolf_oneplus.js             赢一加新品手机
## adolf_mi.js                  Redmi->合成小金刚
## adolf_urge.js                坐等更新
## adolf_superbox.js            京东超级盒子
## adolf_newInteraction.js      618大势新品赏
## jd_try.js                    京东试用
## jd_jbczy.js                  金榜创造营
## jddj_bean.js                 京东到家鲜豆任务
## jddj_fruit.js                京东到家果园任务
## jddj_fruit_collectWater.js   京东到家果园水车
## jddj_getPoints.js            京东到家庄园领水滴
## jddj_plantBeans.js           京东到家鲜豆庄园
## jddj_fruit_code.js           京东到家果园获取互助码

## 京东到家需开通 "到家果园" 活动，自行挑选水果种植跟东东农场类似
## 京东到家账号环境变量： export JDDJ_COOKIE="deviceid_pdj_jd=xxxxxxxx;o2o_m_h5_sid=xxxxxxxx;"  多个账号用英文逗号隔开

##############################  定  义  下  载  代  理  （选填）  ##############################

cat /etc/hosts | grep "raw.githubusercontent.com" -q
if [ $? -ne 0 ]; then
  echo "199.232.28.133 raw.githubusercontent.com" >>/etc/hosts
  echo "199.232.68.133 raw.githubusercontent.com" >>/etc/hosts
  echo "185.199.108.133 raw.githubusercontent.com" >>/etc/hosts
  echo "185.199.109.133 raw.githubusercontent.com" >>/etc/hosts
  echo "185.199.110.133 raw.githubusercontent.com" >>/etc/hosts
  echo "185.199.111.133 raw.githubusercontent.com" >>/etc/hosts
fi
PROXY_URL=https://ghproxy.com/

##############################  作  者  昵  称  （必填）  ##############################

author_list="Public LongZhuZhu adolf adolf ZCY01 passerby-b qqsdf"

##############################  作  者  脚  本  地  址  链  接   （必填）  ##############################

scripts_base_url_1=https://gitee.com/SuperManito/scripts/raw/master/
## 龙王的库
scripts_base_url_2=${PROXY_URL}https://raw.githubusercontent.com/nianyuguai/longzhuzhu/main/qx/
## 庙里的经书
scripts_base_url_3=${PROXY_URL}https://raw.githubusercontent.com/monk-coder/dust/dust/normal/
scripts_base_url_4=${PROXY_URL}https://raw.githubusercontent.com/monk-coder/dust/dust/member/
## 京东试用
scripts_base_url_5=${PROXY_URL}https://raw.githubusercontent.com/ZCY01/daily_scripts/main/jd/
## 京东到家
scripts_base_url_6=${PROXY_URL}https://raw.githubusercontent.com/passerby-b/JDDJ/main/
## 金榜创造营
scripts_base_url_7=${PROXY_URL}https://raw.githubusercontent.com/qqsdff/script/main/jd/

##############################  作  者  脚  本  名  称  （必填）  ##############################

my_scripts_list_1="jd_paopao.js jx_cfdtx.js"
my_scripts_list_2="jd_super_redrain.js jd_half_redrain.js"
my_scripts_list_3="monk_inter_shop_sign.js monk_shop_follow_sku.js monk_shop_lottery.js adolf_pk.js adolf_martin.js adolf_mi.js adolf_urge.js adolf_superbox.js adolf_newInteraction.js"
my_scripts_list_4="adolf_flp.js adolf_oneplus.js"
my_scripts_list_5="jd_try.js"
my_scripts_list_6="jddj_bean.js jddj_fruit.js jddj_fruit_collectWater.js jddj_getPoints.js jddj_plantBeans.js jddj_fruit_code.js jddj_cookie.js"
my_scripts_list_7="jd_jbczy.js"

##############################  随  机  函  数  ##############################
rand() {
  min=$1
  max=$(($2 - $min + 1))
  num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
  echo $(($num % $max + $min))
}
cd ${ShellDir}
index=1
for author in $author_list; do
  echo -e "开始下载 $author 的活动脚本：\n"
  eval scripts_list=\$my_scripts_list_${index}
  #echo $scripts_list
  eval url_list=\$scripts_base_url_${index}
  #echo $url_list
  for js in $scripts_list; do
    eval url=$url_list$js
    echo $url
    eval name=$js
    echo $name
    wget -q --no-check-certificate $url -O scripts/$name.new

    if [ $? -eq 0 ]; then
      mv -f scripts/$name.new scripts/$name
      echo -e "更新 $name 完成...\n"
      croname=$(echo "$name" | awk -F\. '{print $1}')
      script_date=$(cat scripts/$name | grep "http" | awk '{if($1~/^[0-59]/) print $1,$2,$3,$4,$5}' | sort | uniq | head -n 1)
      if [ -z "${script_date}" ]; then
        cron_min=$(rand 1 59)
        cron_hour=$(rand 7 9)
        [ $(grep -c "$croname" ${ListCron}) -eq 0 ] && sed -i "/hangup/a${cron_min} ${cron_hour} * * * bash jd $croname" ${ListCron}
      else
        [ $(grep -c "$croname" ${ListCron}) -eq 0 ] && sed -i "/hangup/a${script_date} bash jd $croname" ${ListCron}
      fi
    else
      [ -f scripts/$name.new ] && rm -f scripts/$name.new
      echo -e "更新 $name 失败，使用上一次正常的版本...\n"
    fi
  done
  index=$(($index + 1))
done

## 京东试用脚本添加取关定时任务
grep -q "（jd_try.js）" ${ListCron} && sed -i "/（jd_try.js）/d" ${ListCron} &&  sed -ie "/5 10 \* \* \* bash jd jd_unsubscribe/d" ${ListCron} ## 修复试用脚本重复通知定时任务的错误

[ -f ${ScriptsDir}/jd_try.js ] && grep -q "5 10 \* \* \* bash jd jd_unsubscribe" ${ListCron}
if [ $? -ne 0 ]; then
  echo -e '\n# 京东试用脚本添加的取关定时任务\n5 10 * * * bash jd jd_unsubscribe' >>${ListCron}
fi

##############################  删  除  失  效  的  活  动  脚  本  ##############################
