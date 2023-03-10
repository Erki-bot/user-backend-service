require 'httpx'
require_relative '../secret_generator'

class WalletController < ApplicationController
  attr_accessor :api_url

  def initialize
    super
    @api_url = 'http://localhost:8081'
  end

  def create_account
    uid = params['uid']
    if uid.nil?
      render json: { error: 'missing uid' }, status: 400
    elsif !alphanumeric? uid
      render json: { error: 'incorrect uid. uid must be alphanumeric' }, status: 400
    else
      secret = secretGenerator 32
      response = HTTPX.post("#{api_url}/wallet", json: { uid: uid, secret: secret })
      if response.status.is_a? Integer
        case response.status
        when 201
          render json: { address: JSON.parse(response.body)['address'], password: secret }, status: 200
        else
          render json: JSON.parse(response.body), status: response.status
        end
      else
        render json: { error: 'cannot connect to the server' }, status: 500
      end
    end
  end

  def get_account
    uid = params['uid']
    secret = params['secret']
    # Verifying if uid and secret are present
    if !uid || !secret
      if !uid && !secret
        render json: { error: 'missing uid and secret' }, status: 400
      elsif !uid
        render json: { error: 'missing uid' }, status: 400
      else
        render json: { error: 'missing secret' }, status: 400
      end
    elsif !alphanumeric?(uid) || !alphanumeric?(secret)
      if !alphanumeric?(uid) && !alphanumeric?(secret)
        render json: { error: 'uid and secret are incorrect' }, status: 400
      elsif !alphanumeric?(uid)
        render json: { error: 'incorrect uid' }, status: 400
      else
        render json: { error: 'incorrect secret' }, status: 400
      end
    else
      response = HTTPX.get("#{api_url}/wallet", json: { uid: uid, secret: secret })
      if response.status.is_a? Integer
        render json: JSON.parse(response.body), status: response.status
      else
        render json: { error: 'cannot connect to the server' }, status: 500
      end
    end
  end

  private

  def alphanumeric?(string)
    string.match(/\A[a-zA-Z0-9]+\z/) != nil
  end
end
