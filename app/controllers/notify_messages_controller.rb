class NotifyMessagesController < ApplicationController
  before_action :set_notify_message, only: %i[show edit update destroy]

  def index
    @notify_messages = NotifyMessage.all
  end

  def show; end

  def new
    @notify_message = NotifyMessage.new
  end

  def edit; end

  def create
    @notify_message = NotifyMessage.new(notify_message_params)

    respond_to do |format|
      if @notify_message.save
        format.html { redirect_to notify_messages_url, notice: t('flash_messages.messages.created') }
        format.json { render :show, status: :created, location: @notify_message }
      else
        format.html { render :new }
        format.json { render json: @notify_message.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @notify_message.update(notify_message_params)
        format.html { redirect_to notify_messages_url, notice: t('flash_messages.messages.updated') }
        format.json { render :show, status: :ok, location: @notify_message }
      else
        format.html { render :edit }
        format.json { render json: @notify_message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @notify_message.destroy
    respond_to do |format|
      format.html { redirect_to notify_messages_url, notice: t('flash_messages.messages.destroyed') }
      format.json { head :no_content }
    end
  end

  private

  def set_notify_message
    @notify_message = NotifyMessage.find(params[:id])
  end

  def notify_message_params
    params.require(:notify_message).permit(:message)
  end
end
